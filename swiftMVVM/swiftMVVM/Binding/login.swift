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
            LoginView(loginViewModel: .init(initialState: .init()))
            LoginView(loginViewModel: .init(initialState: .init()))
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
        email.isEmpty == false && password.isEmpty == false
    }
    
    var footerMessage: String {
        isLoginIn ? "Efetuando login..." : ""
    }
    
    var isLoginInMessage: some View {
        Text(footerMessage)
    }

}

extension Binding{
    init<ObjectType: AnyObject>(
        to path: ReferenceWritableKeyPath<ObjectType, Value> ,
        on object: ObjectType){
            self.init(get: { object[keyPath: path] },
                      set: { object[keyPath: path] = $0 })
        }
}

final class LoginViewModel: ObservableObject {
    
    @Published private(set) var state: LoginViewState
    
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
    
    init(initialState: LoginViewState = .init()) {
        state = initialState
    }
    
    
    func Login(){
        state.isLoginIn = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            self.state.isLoginIn = false
            self.state.isShowingErrorAlert = true
        }
    }
    
    func RestartLoginErrorState() {
        state.isShowingErrorAlert = false
    }
   
    
}
