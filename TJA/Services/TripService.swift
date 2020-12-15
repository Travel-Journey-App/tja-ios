//
//  TripService.swift
//  TJA
//
//  Created by Miron Rogovets on 12.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

protocol TripService {
    typealias TripListResponse = AnyPublisher<APIResponse<[TripResponse]>, APIError>
    typealias TripItemResponse = AnyPublisher<APIResponse<TripResponse>, APIError>
    typealias MessageResponse = AnyPublisher<APIMessageResponse, APIError>
    
    var apiSession: APIService { get }
    
    func getTrips() -> TripListResponse
    func getTrip(id: Int) -> TripItemResponse
    func addTrip(trip: TripRequest) -> TripItemResponse
    func updateTrip(trip: TripRequest) -> TripItemResponse
    func deleteTrip(id: Int) -> MessageResponse
}

extension TripService {
    
    func getTrips() -> TripListResponse {
        return apiSession
            .request(with: TripEndpoint.tripList)
            .eraseToAnyPublisher()
    }
    
    func getTrip(id: Int) -> TripItemResponse {
        return apiSession
            .request(with: TripEndpoint.trip(id: id))
            .eraseToAnyPublisher()
    }
    
    func addTrip(trip: TripRequest) -> TripItemResponse {
        return apiSession
            .request(with: TripEndpoint.newTrip(trip: trip))
            .eraseToAnyPublisher()
    }
    
    func updateTrip(trip: TripRequest) -> TripItemResponse {
        return apiSession
            .request(with: TripEndpoint.updateTrip(trip: trip))
            .eraseToAnyPublisher()
    }
    
    func deleteTrip(id: Int) -> MessageResponse {
        return apiSession
            .request(with: TripEndpoint.deleteTrip(id: id))
            .eraseToAnyPublisher()
    }
	
	func magic(trip: TripRequest) -> TripItemResponse {
        return apiSession
            .request(with: TripEndpoint.magic(trip: trip))
            .eraseToAnyPublisher()
    }
}
