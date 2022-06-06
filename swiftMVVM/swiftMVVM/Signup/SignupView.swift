import SwiftUI

struct SignupView: View {
    
    @ObservedObject var signupViewModel: SignupViewModel
    
    private var passwordCreationView: some View {
        Form{
            Section(header: Text("Crie uma senha")){
                SecureField("senha", text: signupViewModel.passwordBinding)
                    .autocapitalization(.none)
                SecureField("confirme sua senha", text: signupViewModel.passwordCofirmationBinding)
                    .autocapitalization(.none)
            }
            
        }
        .navigationBarTitle("Senha")
        .navigationBarItems(trailing: registerButton)
    }
    
    private var emailCreationView: some View {
        Form{
            Section(header: Text("Insira seu melhor e-mail")){
                TextField("e-mail", text: signupViewModel.emailBinding)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
            }
        }
        .navigationBarTitle("E-mail")
        .navigationBarItems(trailing: advanceButton)
    }
    
    var body: some View {
    
           emailCreationView
            .overlay(
                NavigationLink(destination: passwordCreationView,
                               isActive: signupViewModel.isShowingPasswordCreation,
                               label: {
                                   EmptyView()
                               })
            )
    }
    
    private var advanceButton: some View {
        Button(action: signupViewModel.advanceToPassword) {
            Text("Próximo")
        }.disabled(!signupViewModel.state.canAdvenceToPassword)
    }
    
    private var registerButton: some View {
        Button(action: signupViewModel.finish) {
            Text("Criar")
        }.disabled(!signupViewModel.state.canAdvenceToRegister)
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        
        SignupView(signupViewModel: SignupViewModel(flowCompleted: {}))
    }
}
