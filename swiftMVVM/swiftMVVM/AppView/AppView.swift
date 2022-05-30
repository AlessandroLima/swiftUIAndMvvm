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
            
        case .login:
            //return LoginView(loginViewModel: viewModel)
            return EmptyView()
        case .loggedArea:
            return EmptyView()
        case .none:
            return EmptyView()
        }
    }
}

struct AppView_Previews: PreviewProvider {
    
    @ObservedObject var viewModel: AppViewModel
    
    static var previews: some View {
        AppView(viewModel: .init(sessionService: FakeSessionService(user: nil)))
    }
}
