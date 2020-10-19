//
//  UserData.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import Combine
import SwiftUI


struct User: Codable {
    let name: String
    let email: String
}


class UserData: ObservableObject {
    @Published var currenUser: User?
}
