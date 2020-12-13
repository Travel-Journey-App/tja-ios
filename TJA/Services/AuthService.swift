//
//  AuthService.swift
//  TJA
//
//  Created by Miron Rogovets on 11.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

protocol AuthService {
    
    typealias AuthResponse = AnyPublisher<APIResponse<UserResponse>, APIError>
    
    var apiSession: APIService { get }
    
    func login(email: String, password: String) -> AuthResponse
    func signup(email: String, password: String) -> AuthResponse
    func oauth(idToken: String) -> AuthResponse
    func refresh() -> AuthResponse
}

extension AuthService {
    
    func login(email: String, password: String) -> AuthResponse {
        return apiSession
            .request(with: AuthEndpoint.login(email: email, password: password))
            .eraseToAnyPublisher()
    }
    
    func signup(email: String, password: String) -> AuthResponse {
        return apiSession
            .request(with: AuthEndpoint.signup(email: email, password: password))
            .eraseToAnyPublisher()
    }
    
    func oauth(idToken: String) -> AuthResponse {
        return apiSession
            .request(with: AuthEndpoint.google(token: idToken))
            .eraseToAnyPublisher()
    }
    
    func refresh() -> AuthResponse {
        return apiSession
            .request(with: AuthEndpoint.refresh)
            .eraseToAnyPublisher()
    }
}
