//
//  APIResponse.swift
//  TJA
//
//  Created by Miron Rogovets on 11.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


enum APIMessage: String, Codable {
    case ok = "OK"
    case error = "ERROR"
}


struct APIResponse<T: Codable>: Codable {
    let status: APIMessage
    let error: String?
    let body: T?
    
    func getError() -> APIError? {
        switch status {
        case .ok: return nil
        case .error: return .api(error ?? "No message")
        }
    }
}
