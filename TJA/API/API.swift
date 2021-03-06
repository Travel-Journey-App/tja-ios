//
//  API.swift
//  TJA
//
//  Created by Miron Rogovets on 10.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

protocol APIService {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, APIError>
    func request<T: Decodable>(with builder: RequestBuilder, with decoder: JSONDecoder) -> AnyPublisher<T, APIError>
}

protocol RequestBuilder {
    var base: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var urlRequest: URLRequest? { get }
    var authorizeRequest: Bool { get }
    func body() -> Data?
}

extension RequestBuilder {
    
    var appJsonHeaders: [String: String] {
        [ // HTTPHeaderField : value
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: "\(base)\(path)")
        else { return nil }
        print("DEBUG: -- URL = \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body()
        if let headers = headers {
            for (k, v) in headers {
                request.addValue(v, forHTTPHeaderField: k)
            }
        }
        return authRequestModifier(request)
    }
    
    func authRequestModifier(_ request: URLRequest?) -> URLRequest? {
        guard let r = request else { return request }
        var request = r
        if self.authorizeRequest, let token = UserDefaultsConfig.authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

enum APIError: Error {
    case decodingError(String)
    case httpError(HTTPCode)
    case api(String)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .decodingError(subject): return "Error decoding response: \(subject)"
        case let .httpError(code): return "Unexpected HTTP code: \(code)"
        case let .api(message): return "Sever returned error: \(message)"
        case .unknown: return "Unknown API error"
        }
    }
}


typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
