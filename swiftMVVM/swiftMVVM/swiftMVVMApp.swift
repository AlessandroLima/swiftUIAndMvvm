//
//  swiftMVVMApp.swift
//  swiftMVVM
//
//  Created by Alessandro Teixeira Lima on 20/05/22.
//

import SwiftUI

struct FailWithDelayLoginService: LoginService {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            completion(NSError(domain: "", code: 1, userInfo: nil))
        }
    }
    
    
}

@main
struct swiftMVVMApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView(model: .init())
            LoginView(loginViewModel: .init(
                service: FailWithDelayLoginService(),
                loginDidSuccessed: {})
            )
        }
    }
}
