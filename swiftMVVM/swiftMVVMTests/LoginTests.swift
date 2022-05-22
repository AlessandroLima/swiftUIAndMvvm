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
    
    override func setUp() {
        super.setUp()
        viewModel = .init()
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
        
    }
    
    func testFailableLoginFlow () {
        XCTAssertFalse(viewModel.state.canSubmit)
    }

}
