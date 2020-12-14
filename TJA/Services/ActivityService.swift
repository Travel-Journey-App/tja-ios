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
    
    typealias ActivityResponse = AnyPublisher<APIResponse<Event>, APIError>
    typealias MessageResponse = AnyPublisher<APIMessageResponse, APIError>
    
    var apiSession: APIService { get }
    
    func add(activity: Event) -> ActivityResponse
    func update(activity: Event) -> ActivityResponse
    func delete(by id: Int) -> MessageResponse
}

extension ActivityService {
    
}
