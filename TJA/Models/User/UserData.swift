//
//  UserData.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine


struct User: Codable {
    let email: String
    var name: String? = nil
    var phone: String? = nil
    var birth: Date? = nil
}

struct UserResponse: Codable {
    let firstName: String?
    let lastName: String?
    let email: String
    let secret: String
    
    var fullName: String? {
        if let f = firstName, let l = lastName {
            return "\(f) \(l)"
        } else {
            return nil
        }
    }
    
    var user: User {
        User(email: email, name: fullName, phone: nil, birth: nil)
    }
}

struct UserUpdateRequest: Codable {
    let name: String?
    let phone: String?
    let birthDate: Date?
}
