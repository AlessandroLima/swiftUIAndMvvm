//
//  LoginViewModel.swift
//  swiftMVVM
//
//  Created by Alessandro Teixeira Lima on 23/05/22.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    
    @Published private(set) var state: LoginViewState
    
    private var service: LoginService
     
    private var loginDidSuccessed: () -> Void
    
    // A criação de um Bind na mão garante que os states serão modificados pela model e só por ela.
    
//    var bindings : (
//        email: Binding<String>,
//        password: Binding<String>,
//        isShowingError: Binding<Bool>
//    ){
//        (
//            email:  Binding(get: {self.state.email}, set: { email in
//                self.state.email = email}),
//            password:  Binding(get: {self.state.password}, set: { password in
//                self.state.password = password}),
//            isShowingError:  Binding(get: {self.state.isShowingErrorAlert}, set: {
//                isShowingError in self.state.isShowingErrorAlert = isShowingError})
//        )
//
//    }
    
    var bindings : (
        email: Binding<String>,
        password: Binding<String>,
        isShowingErrorAlert: Binding<Bool>
    ){
        (
            email:  Binding(to: \.state.email, on: self),
            password:  Binding(to: \.state.password, on: self),
            isShowingErrorAlert:  Binding(to: \.state.isShowingErrorAlert, on: self)
        )
        
    }
    
    init(initialState: LoginViewState = .init(),
         service: LoginService,
         loginDidSuccessed: @escaping ()->Void) {
        self.state = initialState
        self.service = service
        self.loginDidSuccessed = loginDidSuccessed
    }
    
    
    func Login(){
        
        state.isLoginIn = true
        
          service.login(
            email: state.email,
            password: state.password) { [weak self] erro in
                
                if erro == nil {
                    self?.loginDidSuccessed()
                } else {
                    self?.state.isLoginIn = false
                    self?.state.isShowingErrorAlert = true
                }
            }
    }
    
    func RestartLoginErrorState() {
        state.isShowingErrorAlert = false
    }
   
    
}
