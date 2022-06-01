//
//  Binding+Extension.swift
//  swiftMVVM
//
//  Created by Alessandro Teixeira Lima on 23/05/22.
//

import SwiftUI

extension Binding{
    init<ObjectType: AnyObject>(
        to path: ReferenceWritableKeyPath<ObjectType, Value> ,
        on object: ObjectType){
            self.init(get: { object[keyPath: path] },
                      set: { object[keyPath: path] = $0 })
        }
}
