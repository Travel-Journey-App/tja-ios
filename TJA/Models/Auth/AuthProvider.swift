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
