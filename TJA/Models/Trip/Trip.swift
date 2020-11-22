//
//  Trip.swift
//  TJA
//
//  Created by Miron Rogovets on 16.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

struct Trip: Hashable, Codable, Identifiable {
    let id: Int
    let image: URL?
    let name: String
    let startDate: Date
    let endDate: Date
    let location: Location?
    
    var isFinished: Bool {
        return Date().compare(to: endDate) == .orderedDescending
    }
    
    var hasStarted: Bool {
        return startDate.isToday() || startDate.compare(to: Date()) == .orderedAscending
    }
    
    var inProgress: Bool {
        return hasStarted && !isFinished
    }
    
    var daysInOrAgo: String {
        remainingOrAgoFormatter.recentString(between: startDate, and: Date())
            ?? dateFormatter.string(from: startDate)
    }
    
    var interval: String {
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
}


struct TripDay: Hashable, Codable, Identifiable {
    let id: Int
    let number: Int
    let events: [Event]
}
