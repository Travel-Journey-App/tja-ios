//
//  AuthProvider.swift
//  TJA
//
//  Created by Miron Rogovets on 03.11.2020.
//

import Foundation


enum AuthProvider {
    case google
    case emailAndPassword(email: String, password: String)
}
