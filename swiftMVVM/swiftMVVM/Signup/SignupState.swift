import Foundation

struct SignupState {
    var email: String = ""
    var isShowingPasswordCreation = false
    var password: String = ""
    var passwordConfirmation: String = ""
    var ispasswordValid: Bool = false
    
    
}

extension SignupState {
    var canAdvenceToPassword: Bool { !email.isEmpty }
    var canAdvenceToRegister: Bool {!password.isEmpty && !passwordConfirmation.isEmpty && password == passwordConfirmation
    }
}
