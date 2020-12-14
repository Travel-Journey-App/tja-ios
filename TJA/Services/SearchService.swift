//
//  SearchService.swift
//  TJA
//
//  Created by Miron Rogovets on 14.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

protocol SearchService {
    
    typealias SearchResponse<T: Codable> = AnyPublisher<APISearchResponse<T>, APIError>
    
    var apiSession: APIService { get }
    
    func search(destination query: String) -> SearchResponse<CityResponse>
    func search(wish category: WishItem, for destination: String) -> SearchResponse<SuggestionPlace>
    func search(accommodation query: String, for destination: String)
    func search(transferPoint query: String, in category: String, for destination: String)
    func search(eventPlace query: String, in category: String, for destination: String)
}

extension SearchService {
    
    func search(destination query: String) -> SearchResponse<CityResponse> {
        return apiSession
            .request(with: SearchEndpoint.city(query: query))
            .eraseToAnyPublisher()
    }
    
    func search(wish category: WishItem, for destination: String) -> SearchResponse<SuggestionPlace> {
        return apiSession
            .request(with: SearchEndpoint.suggestion(category: category.rawValue, destination: destination))
            .eraseToAnyPublisher()
    }
    
    func search(accommodation query: String, for destination: String) {
        
    }
    
    func search(transferPoint query: String, in category: String, for destination: String) {
        
    }
    
    func search(eventPlace query: String, in category: String, for destination: String) {
        
    }
}
