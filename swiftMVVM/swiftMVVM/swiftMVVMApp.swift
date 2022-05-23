//
//  swiftMVVMApp.swift
//  swiftMVVM
//
//  Created by Alessandro Teixeira Lima on 20/05/22.
//

import SwiftUI

@main
struct swiftMVVMApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView(model: .init())
            LoginView(loginViewModel: .init(
                service: EmptyLoginService(),
                loginDidSuccessed: {})
            )
        }
    }
}
