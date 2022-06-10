import Foundation
import SwiftUI

final class SignupViewModel: ObservableObject, Identifiable {
    
    @Published private(set) var state: SignupState
    
    let flowCompleted: ()->Void
    
    init(initialState: SignupState = .init(), flowCompleted: @escaping ()->Void) {
        self.state = initialState
        self.flowCompleted = flowCompleted
    }
    
    func advanceToPassword() {
        guard state.canAdvenceToPassword else {
            return
        }
        state.isShowingPasswordCreation = true
    }
    
    func finish() {
        guard state.canAdvenceToRegister else {
            return
        }
        state.ispasswordValid = true
        
        flowCompleted()
    }
    
}

//MARK: - Bindings
  
extension SignupViewModel {
    var emailBinding: Binding<String> {
        Binding(to: \.state.email, on: self)
    }
    
    var passwordBinding: Binding<String> {
        Binding(to: \.state.password, on: self)
    }
    
    var passwordCofirmationBinding: Binding<String> {
        Binding(to: \.state.passwordConfirmation, on: self)
    }
    
    var isShowingRegisterCreationBinding: Binding<Bool> {
        Binding(to: \.state.ispasswordValid, on: self)
    }
    
    var isShowingPasswordCreation: Binding<Bool> {
        Binding(to: \.state.isShowingPasswordCreation, on: self)
    }
    
}

//MARK: - Equatable

extension SignupViewModel: Equatable {
    static func == (lhs: SignupViewModel, rhs: SignupViewModel) -> Bool {
        lhs === rhs
    }
}
