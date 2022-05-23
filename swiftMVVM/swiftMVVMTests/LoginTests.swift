//
//  LoginTests.swift
//  swiftMVVMUITests
//
//  Created by Alessandro Teixeira Lima on 22/05/22.
//

@testable import swiftMVVM
import XCTest


class LoginTests: XCTestCase {
    
    private var viewModel: LoginViewModel!
    private var service: LoginServiceMock!
    private var didCallloginDidSuccessed: Bool!
    
    override func setUp() {
        super.setUp()
        service = .init()
        didCallloginDidSuccessed = false
        viewModel = .init(service: service,
                          loginDidSuccessed:{ [weak self] in
            self?.didCallloginDidSuccessed = true
            
        }
        )
    }
    
    func testDefultInitialState (){
        XCTAssertEqual(viewModel.state,
                       LoginViewState(email: "",
                                      password: "",
                                      isLoginIn: false,
                                      isShowingErrorAlert: false))
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
        
    }
    
    func testSuccessFullLoginFlow () {
        
        //usamos wrappedValue para poder escrever no binding
        viewModel.bindings.email.wrappedValue = "aletlima@gmail.com"
        viewModel.bindings.password.wrappedValue = "123456"
        XCTAssertTrue(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
        
        viewModel.Login()
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssert(!viewModel.state.footerMessage.isEmpty)
        
        XCTAssertEqual(viewModel.state,
                       LoginViewState(email: "aletlima@gmail.com",
                                      password: "123456",
                                      isLoginIn: true,
                                      isShowingErrorAlert: false))
        
        XCTAssertEqual(service.lastReceivedEmail, "aletlima@gmail.com")
        XCTAssertEqual(service.lastReceivedPassword, "123456")
        
        //como estamos chamando login com sucesso chamamos (Simulamos uma resposta do servidor):
        service.completion?(nil)
        
        XCTAssert(didCallloginDidSuccessed)
        
    }
    
    func testFailableLoginFlow () {
        
        //usamos wrappedValue para poder escrever no binding
        viewModel.bindings.email.wrappedValue = "aletlima@gmail.com"
        viewModel.bindings.password.wrappedValue = "123456"
        XCTAssertTrue(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
        
        viewModel.Login()
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssert(!viewModel.state.footerMessage.isEmpty)
        
        XCTAssertEqual(viewModel.state,
                       LoginViewState(email: "aletlima@gmail.com",
                                      password: "123456",
                                      isLoginIn: true,
                                      isShowingErrorAlert: false))
        XCTAssertEqual(service.lastReceivedEmail, "aletlima@gmail.com")
        XCTAssertEqual(service.lastReceivedPassword, "123456")
        
        //como estamos chamando login com sucesso chamamos (Simulamos uma resposta do servidor):
        struct FakeError: Error {}
        service.completion?(FakeError())
        
        XCTAssertEqual(viewModel.state,
                       LoginViewState(email: "aletlima@gmail.com",
                                      password: "123456",
                                      isLoginIn: false,
                                      isShowingErrorAlert: true))
        
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
        
        XCTAssert(didCallloginDidSuccessed)
    }
    
}

private final class LoginServiceMock: LoginService {
    
    var lastReceivedEmail: String?
    var lastReceivedPassword: String?
    var completion: ((Error?) -> Void)?
    
    func login(email: String,
               password: String,
               completion: @escaping (Error?) -> Void) {
        
        self.lastReceivedEmail = email
        self.lastReceivedPassword = password
        self.completion = completion
    }
    
    
}
