//
//  SuggestionPlace.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

struct SuggestionPlace: Hashable, Codable, Identifiable, Comparable {
    
    enum Price: String, Codable {
        case cheap, medium, expensive
    }
    
    struct WorkingHours: Codable, Hashable {
        let open: TimeInterval
        let close: TimeInterval
    }
    
    let id: String
    let category: WishItem
    let description: String
    let workingHours: WorkingHours?
    let price: Price?
    let location: PlaceLocation
    let name: String
    let photo: URL?
    let rating: Double
    let extraName: String
    
    var ratingString: String {
        return "\(rating.round(to: 1))"
    }
    
    var workingHoursString: String {
        guard let hours = workingHours else { return "Open" }
        let start = Date().startOf(.day).addingTimeInterval(hours.open)
        let end: Date = hours.close <= hours.open
            ? Date().startOf(.day).addingTimeInterval(hours.close + .day)
            : Date().startOf(.day).addingTimeInterval(hours.close)
        return "Open: \(start.localizedTimeString()) - \(end.localizedTimeString())"
    }
    
    var cost: String {
        switch price {
        case .none: return ""
        case .cheap: return "$"
        case .medium: return "$$"
        case .expensive: return "$$$"
        }
    }
    
    static func < (lhs: SuggestionPlace, rhs: SuggestionPlace) -> Bool {
        return lhs.rating < rhs.rating
    }
}


extension SuggestionPlace {
    
    func activityRequest(for startDate: Date, day number: Int) -> ActivityRequest.New.Event {
        
        let start: Date?
        let end: Date?
        
        if let hours = workingHours {
            start = startDate.addingTimeInterval(.day * Double((number - 1)) + hours.open)
            end = startDate.addingTimeInterval(.day * Double((number - 1)) + hours.close)
        } else {
            start = nil
            end = nil
        }
        
        return .init(
            name: name,
            description: description,
            startTime: start,
            endTime: end,
            note: "",
            lat: location.lat,
            lon: location.lon,
            activityType: "event",
            eventType: category.activity.rawValue)
    }
}
