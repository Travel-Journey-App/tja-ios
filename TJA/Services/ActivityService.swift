//
//  ActivityService.swift
//  TJA
//
//  Created by Miron Rogovets on 14.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

protocol ActivityService {
    
    typealias ItemResponse = AnyPublisher<APIResponse<ActivityResponse>, APIError>
    typealias MessageResponse = AnyPublisher<APIMessageResponse, APIError>
    
    var apiSession: APIService { get }
    
    func add(activity: Activity, to trip: Int, on day: Int) -> ItemResponse
    func update(activity: Activity, in trip: Int, on day: Int) -> ItemResponse
    func delete(by id: Int, from trip: Int, on day: Int) -> MessageResponse
}

extension ActivityService {
    
    func add(activity: Activity, to trip: Int, on day: Int) -> ItemResponse {
        return apiSession
            .request(with: ActivityEndpoint.newActivity(tripId: trip, dayId: day))
            .eraseToAnyPublisher()
    }
    
    func update(activity: Activity, in trip: Int, on day: Int) -> ItemResponse {
        return apiSession
            .request(with: ActivityEndpoint.updateActivity(tripId: trip, dayId: day))
            .eraseToAnyPublisher()
    }
    
    func delete(by id: Int, from trip: Int, on day: Int) -> MessageResponse {
        return apiSession
            .request(with: ActivityEndpoint.deleteActivity(tripId: trip, dayId: day))
            .eraseToAnyPublisher()
    }
}
