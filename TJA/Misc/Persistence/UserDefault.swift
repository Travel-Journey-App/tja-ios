//
//  UserDefault.swift
//  TJA
//
//  Created by Miron Rogovets on 10.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    public let key: String
    public let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
public struct OptionalUserDefault<T> {
    public let key: String
    public let defaultValue: T?

    public init(_ key: String, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}

@propertyWrapper
public struct ArrayUserDefault<T> {
    public let key: String
    public let defaultValue: [T]

    public init(_ key: String, defaultValue: [T] = []) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: [T] {
        get {
            return UserDefaults.standard.array(forKey: key) as? [T] ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
