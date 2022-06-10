import XCTest
@testable import swiftMVVM

class SignupStateTests: XCTestCase {

    func test_emailIsEmptyCannotAdvenceToPassword () {
        
        XCTAssertFalse(SignupState(email: "").canAdvenceToPassword)
    }
    
    func test_emailIsNotEmptyCanAdvenceToPassword () {
        
        XCTAssert(SignupState(email: "aletlima@gmail.com").canAdvenceToPassword)
    }
    
}
