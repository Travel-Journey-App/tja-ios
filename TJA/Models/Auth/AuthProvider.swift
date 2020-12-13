//
//  AuthProvider.swift
//  TJA
//
//  Created by Miron Rogovets on 03.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


enum AuthProvider {
    case google
    case emailAndPassword(email: String, password: String)
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct SignUpRequest: Codable {
    let email: String
    let password: String
    let matchingPassword: String
}

struct OAuthRequest: Codable {
    let googleOAuthToken: String
}
