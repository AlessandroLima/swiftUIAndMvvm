//
//  LoginTests.swift
//  swiftMVVMUITests
//
//  Created by Alessandro Teixeira Lima on 22/05/22.
//

@testable import swiftMVVM
import XCTest


class LoginTests: XCTestCase {
    
    private var loginViewModel: LoginViewModel!
    private var service: LoginServiceMock!
    private var didCallloginDidSuccessed: Bool!
    
    override func setUp() {
        super.setUp()
        service = .init()
        didCallloginDidSuccessed = false
        loginViewModel = .init(service: service,
                          loginDidSuccessed:{ [weak self] in
            self?.didCallloginDidSuccessed = true
            
        }
        )
    }
    
    func testDefultInitialState (){
        XCTAssertEqual(loginViewModel.state,
                       LoginViewState(email: "",
                                      password: "",
                                      isLoginIn: false,
                                      isShowingErrorAlert: false))
        XCTAssertFalse(loginViewModel.state.canSubmit)
        XCTAssert(loginViewModel.state.footerMessage.isEmpty)
        
    }
    
    func testSuccessFullLoginFlow () {
        
        //usamos wrappedValue para poder escrever no binding
        loginViewModel.bindings.email.wrappedValue = "aletlima@gmail.com"
        loginViewModel.bindings.password.wrappedValue = "123456"
        XCTAssertTrue(loginViewModel.state.canSubmit)
        XCTAssert(loginViewModel.state.footerMessage.isEmpty)
        
        loginViewModel.Login()
        XCTAssertFalse(loginViewModel.state.canSubmit)
        XCTAssert(!loginViewModel.state.footerMessage.isEmpty)
        
        XCTAssertEqual(loginViewModel.state,
                       LoginViewState(email: "aletlima@gmail.com",
                                      password: "123456",
                                      isLoginIn: true,
                                      isShowingErrorAlert: false))
        
        XCTAssertEqual(service.lastReceivedEmail, "aletlima@gmail.com")
        XCTAssertEqual(service.lastReceivedPassword, "123456")
        
        //como estamos chamando login com sucesso chamamos (Simulamos uma resposta do servidor):
        service.completion?(nil)
        
        //XCTAssert(didCallloginDidSuccessed)
        
    }
    
    func testFailableLoginFlow () {
        
        //usamos wrappedValue para poder escrever no binding
        loginViewModel.bindings.email.wrappedValue = "aletlima@gmail.com"
        loginViewModel.bindings.password.wrappedValue = "123456"
        XCTAssertTrue(loginViewModel.state.canSubmit)
        XCTAssert(loginViewModel.state.footerMessage.isEmpty)
        
        loginViewModel.Login()
        XCTAssertFalse(loginViewModel.state.canSubmit)
        XCTAssert(!loginViewModel.state.footerMessage.isEmpty)
        
        XCTAssertEqual(loginViewModel.state,
                       LoginViewState(email: "aletlima@gmail.com",
                                      password: "123456",
                                      isLoginIn: true,
                                      isShowingErrorAlert: false))
        XCTAssertEqual(service.lastReceivedEmail, "aletlima@gmail.com")
        XCTAssertEqual(service.lastReceivedPassword, "123456")
        
        //como estamos chamando login com sucesso chamamos (Simulamos uma resposta do servidor):
        struct FakeError: Error {}
        service.completion?(FakeError())
        
        XCTAssertEqual(loginViewModel.state,
                       LoginViewState(email: "aletlima@gmail.com",
                                      password: "123456",
                                      isLoginIn: false,
                                      isShowingErrorAlert: true))
        
        XCTAssert(loginViewModel.state.canSubmit)
        XCTAssert(loginViewModel.state.footerMessage.isEmpty)
        
        XCTAssertFalse(didCallloginDidSuccessed)
    }
    
    func test_showSignupflow_createsSignupViewModel() {
        loginViewModel.showSignupFlow()
        XCTAssertNotNil(loginViewModel.state.signupViewModel)
        
    }
    
    func test_signupBinding_readsValueFromState() {
        loginViewModel.showSignupFlow()
        XCTAssertNotNil(loginViewModel.bindings.signupViewModel.wrappedValue)
    
    }
    
    func test_signupBinding_writesValueToState() {
        loginViewModel.showSignupFlow()
        loginViewModel.bindings.signupViewModel.wrappedValue = nil
        XCTAssertNil(loginViewModel.bindings.signupViewModel.wrappedValue)
    
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
