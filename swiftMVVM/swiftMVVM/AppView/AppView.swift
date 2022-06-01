//
//  AppView.swift
//  swiftMVVM
//
//  Created by Alessandro Teixeira Lima on 30/05/22.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        
        switch viewModel.state {
            
        case let .login(viewModel):
            return AnyView (
                LoginView(loginViewModel: viewModel)
            )
            
        case let .loggedArea(sessionService):
            return AnyView(
                VStack{
                    Text("Bem vindo!")
                    Button(action: sessionService.logout,
                           label: {
                        Text("log out")
                    })
                }
            )
        
        case .none:
            return AnyView(EmptyView())
        }
    }
}

struct AppView_Previews: PreviewProvider {
    
    @ObservedObject var viewModel: AppViewModel
    
    static var previews: some View {
        AppView(viewModel: .init(sessionService: FakeSessionService(user: nil)))
            .preferredColorScheme(.dark)
    }
}
