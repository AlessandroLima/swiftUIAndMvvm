import XCTest
@testable import swiftMVVM

final class SignupViewModelTests: XCTestCase {

    func test_emailBinding_readsValueFromState() {
       let sut =  self.makeSUT(state: SignupState(email: "aletlima@gmail.com"))
        XCTAssertEqual(sut.emailBinding.wrappedValue, "aletlima@gmail.com")
    
    }
    
    func test_emailBinding_writesValueToState() {
        let sut =  self.makeSUT(state: SignupState(email: "aletlima@gmail.com"))
        sut.emailBinding.wrappedValue = ""
        XCTAssert(sut.state.email.isEmpty)
     
    
    }
    
    func test_passwordBinding_readsValueFromState() {
       let sut =  self.makeSUT(state: SignupState(password: "a"))
        XCTAssertEqual(sut.passwordBinding.wrappedValue, "a")
    
    }
    
    func test_passwordBinding_writesValueToState() {
        let sut =  self.makeSUT(state: SignupState(password: "a"))
        sut.passwordBinding.wrappedValue = "b"
        XCTAssertEqual(sut.passwordBinding.wrappedValue, "b")
     
    
    }
    
    func test_advancedToPasswordCreation_whenEmailIsValid_updatesState() {
        let sut =  self.makeSUT(state: SignupState(email: "aletlima@gmail.com"))
        sut.advanceToPassword()
        XCTAssert(sut.state.isShowingPasswordCreation)
    }
    
    func test_advancedToPasswordCreation_whenEmailIsNotValid_doesNotUpdateState() {
        let sut =  self.makeSUT(state: SignupState(email: ""))
        sut.advanceToPassword()
        XCTAssertFalse(sut.state.isShowingPasswordCreation)
    }
    
    func test_isShowingPasswordCreationBinding_readsValueFromState() {
       let sut =  self.makeSUT(state: SignupState(isShowingPasswordCreation: true))
       XCTAssertEqual(sut.isShowingPasswordCreation.wrappedValue, true)
    
    }
    
    func test_isShowingPasswordCreationBinding_writesValueToState() {
        let sut =  self.makeSUT(state: SignupState(isShowingPasswordCreation: true))
        sut.isShowingPasswordCreation.wrappedValue = false
        XCTAssertFalse(sut.isShowingPasswordCreation.wrappedValue)
     
    
    }
    
    func test_advancedToRegisterCreation_whenPasswordIsValid_updatesState() {
        let sut =  self.makeSUT(state: SignupState(password: "a", passwordConfirmation: "a"))
        sut.finish()
        XCTAssert(sut.state.ispasswordValid)
    }
    
    func test_advancedToRegisterCreation_whenPasswordIsNotValid_doesNotUpdateState() {
        let sut =  self.makeSUT(state: SignupState(password: ""))
        sut.finish()
        XCTAssertFalse(sut.state.ispasswordValid)
    }
    
    func test_passwordIsValide_cannotFinish(){
        let sut =  self.makeSUT(state: SignupState(password: "a",passwordConfirmation: "a"))
        XCTAssert(sut.state.canAdvenceToRegister)
    }
    
    func test_passwordIsNotValide_cannotFinish(){
        let sut =  self.makeSUT(state: SignupState(password: "",passwordConfirmation: ""))
        XCTAssertFalse(sut.state.canAdvenceToRegister)
    }
    
    func test_passwordIsEmpty_cannotFinish(){
        let sut =  self.makeSUT(state: SignupState(password: "",passwordConfirmation: "a"))
        XCTAssertFalse(sut.state.canAdvenceToRegister)
    }
    
    func test_confirmPasswordIsEmpty_cannotFinish(){
        let sut =  self.makeSUT(state: SignupState(password: "a",passwordConfirmation: ""))
        XCTAssertFalse(sut.state.canAdvenceToRegister)
    }
    
    func test_passwordAndConfirmPasswordAreDifferent(){
        let sut =  self.makeSUT(state: SignupState(password: "bXZxZX",passwordConfirmation: "aZXZXZXZXXZX"))
        XCTAssertFalse(sut.state.canAdvenceToRegister)
    }
    
    
    
}

private extension SignupViewModelTests {
    func makeSUT(state: SignupState)-> SignupViewModel {
        .init(initialState: state)
    }
    
}
