//
//  UserData.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import Foundation
import Combine


struct User: Codable {
    let name: String
    let email: String
    
    var phone: String? = nil
    var birth: String? = nil
}


class UserData: ObservableObject {
    @Published var currenUser: User?
}
