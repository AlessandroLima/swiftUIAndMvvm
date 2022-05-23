//
//  SwiftUIView.swift
//  swiftMVVM
//
//  Created by Alessandro Teixeira Lima on 21/05/22.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject private var model: LoginViewModel
    
    init(loginViewModel: LoginViewModel) {
        model = loginViewModel
    }
  
    fileprivate func showLoginErrorAlert() -> Alert {
        return Alert(title: Text("Erro ao logar!"), message: Text("Verifique seu e-mail e senha e e tente novamente mais tarde."), dismissButton: Alert.Button.default(Text("OK"), action: model.RestartLoginErrorState))
    }
    
    var body: some View {
        NavigationView {
            Form{
                Section(footer: model.state.isLoginInMessage){
                    TextField("email", text: model.bindings.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("senha", text: model.bindings.password)
                        .autocapitalization(.none)
                }
            }
            .navigationBarItems(trailing: submitButton)
            .navigationBarTitle("Indentifique-se")
            .disabled(model.state.isLoginIn)
            .alert(isPresented: model.bindings.isShowingErrorAlert) {
                showLoginErrorAlert()
                
            }
            
        }
        
    }
    
    private var submitButton: some View {
        Button("Logar", action: model.Login)
            .disabled(model.state.canSubmit == false)
    }
    
   
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(loginViewModel: .init(
                service: EmptyLoginService(),
                loginDidSuccessed: {})
            )
        }
    }
}


struct LoginViewState: Equatable {
    var email = "" {
        didSet {
            print("email: \(email)")
        }
    }
   var password = ""
   var isLoginIn = false
   var isShowingErrorAlert = false {
        didSet {
            print("isShowingError: \(isShowingErrorAlert)")
        }
    }
    
}

extension LoginViewState {
    
    var canSubmit: Bool {
        email.isEmpty == false && password.isEmpty == false && isLoginIn == false
    }
    
    var footerMessage: String {
        isLoginIn ? "Efetuando login..." : ""
    }
    
    var isLoginInMessage: some View {
        Text(footerMessage)
    }

}


struct EmptyLoginService: LoginService {
    
    func login(email: String,
               password: String,
               completion: @escaping (Error?) -> Void) {}
    
}

