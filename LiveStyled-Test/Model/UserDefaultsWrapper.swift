//
//  UserDefaultsWrapper.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/8/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
        } set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
