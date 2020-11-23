//
//  EventService.swift
//  TJA
//
//  Created by Miron Rogovets on 23.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

class EventService: NSObject, ObservableObject {
    @Published var tripDays: [TripDay]
    
    init(days count: Int = 5, start date: Date = Date()) {
        self.tripDays = Mockup.Events.generateDays(numberOfDays: count, start: date)
    }
    
    func filterBy(day number: Int?) -> [Event] {
        if let n = number {
            print("DEBUG: -- Applying filter for day = \(n)")
            return tripDays.first(where: {$0.number == n})?.events ?? []
        } else {
            print("DEBUG: -- Reseting filter to all days")
            return events
        }
    }
    
    var daysCount: Int {
        tripDays.count
    }
    
    var events: [Event] {
        tripDays.flatMap(\.events)
    }
}
