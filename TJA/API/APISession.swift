//
//  APISession.swift
//  TJA
//
//  Created by Miron Rogovets on 11.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

struct APISession: APIService {
    
    static let shared = APISession()
    
    func request<T>(with builder: RequestBuilder) -> AnyPublisher<T, APIError> where T: Decodable {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return request(with: builder, with: decoder)
    }
    
    func request<T>(with builder: RequestBuilder, with decoder: JSONDecoder) -> AnyPublisher<T, APIError> where T : Decodable {
        guard let request = builder.urlRequest else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                #if DEBUG
                print(String(data: data, encoding: .utf8))
                #endif
                if let response = response as? HTTPURLResponse {
                    if HTTPCodes.success.contains(response.statusCode) {
                    return Just(data)
                        .decode(type: T.self, decoder: decoder)
                        .mapError {err in .decodingError(err.localizedDescription)}
                        .eraseToAnyPublisher()
                    } else {
                        return Fail(error: APIError.httpError(response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: APIError.unknown)
                        .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
