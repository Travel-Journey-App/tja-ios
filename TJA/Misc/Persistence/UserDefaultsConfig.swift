//
//  UserDefaultsConfig.swift
//  TJA
//
//  Created by Miron Rogovets on 10.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

public struct UserDefaultsConfig {
    public static let defaults = UserDefaults.standard
    
    @UserDefault("google-provider", defaultValue: false)
    public static var googleProviderWasUsed: Bool
    
    @UserDefault("sync-with-calendar", defaultValue: false)
    public static var syncWithCalendar: Bool
    
    @OptionalUserDefault("auth-token", defaultValue: nil)
    public static var authToken: String?
}
