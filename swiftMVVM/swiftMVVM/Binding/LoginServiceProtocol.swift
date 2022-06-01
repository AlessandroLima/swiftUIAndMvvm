//
//  LoginService.swift
//  swiftMVVM
//
//  Created by Alessandro Teixeira Lima on 23/05/22.
//

import Foundation

protocol LoginService {
    func login(
                email:String,
                password: String,
                completion: @escaping (Error?) -> Void
    )
}
