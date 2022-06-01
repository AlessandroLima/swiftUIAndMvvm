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
            //completion(NSError(domain: "", code: 1, userInfo: nil))
            completion(nil)
        }
    }
}

struct DelayLoginService: LoginService {
    func login(email: String,
               password: String,
               completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            completion(nil)
        }
    }
    
}


@main
struct swiftMVVMApp: App {
    var body: some Scene {
        WindowGroup {
            
            AppView(viewModel: .init(sessionService: FakeSessionService(user: nil)))
                .preferredColorScheme(.dark)
//            LoginView(loginViewModel: .init(
//                service: DelayLoginService(),
//                loginDidSuccessed: {})
//            )
        }
    }
}
