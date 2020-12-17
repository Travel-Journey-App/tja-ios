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
    var days: [TripDay]
    
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
        if hasStarted && !isFinished { return "Today" }
        else {
            return remainingOrAgoFormatter.recentString(between: startDate, and: Date())
            ?? dateFormatter.string(from: startDate)
        }
    }
    
    var interval: String {
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
    
    func updated(with name: String) -> Trip {
        return Trip(
            id: self.id,
            image: self.image,
            name: name,
            startDate: self.startDate,
            endDate: self.endDate,
            location: self.location,
            days: self.days)
    }
}


struct TripDay: Hashable, Codable, Identifiable {
    let id: Int
    let orderInTrip: Int
    var activities: [SwipeableItem<Activity>]
    
    var number: Int {
        orderInTrip
    }
    
    enum DecodingKeys: CodingKey {
        case id, orderInTrip, activities
    }
    
    enum EncodingKeys: CodingKey {
        case id, orderInTrip
    }
    
    static func == (lhs: TripDay, rhs: TripDay) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(id: Int, orderInTrip: Int, activities: [ActivityResponse]) {
        self.id = id
        self.orderInTrip = orderInTrip
        self.activities = activities.compactMap { .init(item: $0.activityItem, offset: 0, isSwiped: false) }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.orderInTrip = try container.decode(Int.self, forKey: .orderInTrip)
        let activities = try container.decode([ActivityResponse]?.self, forKey: .activities) ?? []
        self.activities = activities.compactMap { .init(item: $0.activityItem, offset: 0, isSwiped: false) }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(orderInTrip, forKey: .orderInTrip)
    }
}
