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
    func search(accommodation query: String, for destination: String) -> SearchResponse<AccommodationLocation>
    func search(transferPoint query: String, in category: String, for destination: String) -> SearchResponse<TransferLocation>
    func search(eventPlace query: String, in category: String, for destination: String) -> SearchResponse<SuggestionPlace>
}

extension SearchService {
    
    func search(destination query: String) -> SearchResponse<CityResponse> {
        return apiSession
            .request(with: SearchEndpoint.city(query: query))
            .eraseToAnyPublisher()
    }
    
    func search(wish category: WishItem, for destination: String) -> SearchResponse<SuggestionPlace> {
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return apiSession
            .request(
                with: SearchEndpoint.suggestion(category: category.rawValue, destination: destination),
                with: decoder
            )
            .eraseToAnyPublisher()
    }
    
    func search(accommodation query: String, for destination: String) -> SearchResponse<AccommodationLocation> {
        return apiSession
            .request(with: SearchEndpoint.accommodation(query: query, destination: destination))
            .eraseToAnyPublisher()
    }
    
    func search(transferPoint query: String, in category: String, for destination: String) -> SearchResponse<TransferLocation> {
        return apiSession
            .request(with: SearchEndpoint.transferPoint(query: query, category: category, destination: destination))
            .eraseToAnyPublisher()
    }
    
    func search(eventPlace query: String, in category: String, for destination: String) -> SearchResponse<SuggestionPlace> {
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return apiSession
            .request(
                with: SearchEndpoint.eventPlace(query: query, category: category, destination: destination),
                with: decoder
            )
            .eraseToAnyPublisher()
    }
}
