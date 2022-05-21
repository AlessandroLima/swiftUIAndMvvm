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
        return Alert(title: Text("Erro ao logar!"), message: Text("Verifique seu e-mail e senha e e tente novamente mais tarde."), dismissButton: Alert.Button.default(Text("OK"), action: RestartLoginErrorState))
    }
    
    var body: some View {
        NavigationView {
            Form{
                Section(footer: isLoginInMessage){
                    TextField("email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("senha", text: $password)
                        .autocapitalization(.none)
                }
            }
            .navigationBarItems(trailing: submitButton)
            .navigationBarTitle("Indentifique-se")
            .disabled(isLoginIn)
            .alert(isPresented: $isShowingError) {
                showLoginErrorAlert()
                
            }
            
        }
        
    }
    
    private var submitButton: some View {
        Button("Logar", action: Login)
            .disabled(email.isEmpty || password.isEmpty)
    }
    
   
    
    private var isLoginInMessage: some View {
        Text(isLoginIn ? "Efetuando login..." : "")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        
            LoginView()
    }
}



struct Previews_login_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

struct LoginViewState {
   var email = ""
   var password = ""
   var isLoginIn = false
   var isShowingError = false {
        didSet {
            print("isShowingError: \(isShowingError)")
        }
    }
}

final class LoginViewModel: ObservableObject {
    
    public private(set) var state: LoginViewState
    
    init(initialState: LoginViewState) {
        state = initialState
    }
    
    func Login(){
        state.isLoginIn = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            self.state.isLoginIn = false
            self.state.isShowingError = true
        }
    }
    
    func RestartLoginErrorState() {
        state.isShowingError = false
    }
   
    
}
