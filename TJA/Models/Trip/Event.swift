//
//  Event.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


struct Event: Hashable, Codable, Identifiable, Comparable {
    
    // TODO: Revert to scheduled and unscheduled when proper sort is discussed
    
    let id: Int
    let eventType: EventType
    let name: String
    let note: String
//    let startTime: Date
//    let endTime: Date
    let time: Date
    let location: Location?
    
    var scheduled: Bool {
//        return startTime == endTime
        true
    }
    
    var exactTime: Date {
//        startTime
        time
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.exactTime < rhs.exactTime
//        if !lhs.scheduled && !rhs.scheduled {
//            return lhs.endTime < rhs.endTime
//        } else {
//            return lhs.exactTime < rhs.exactTime
//        }
    }
}


enum EventType: Codable {
    
    enum Activity: String, Codable {
        case food
        case bar
        case gallery
        case museum
        case sightseeing
        case fun
    }
    
    enum Transfer: String, Codable {
        case plane
        case train
        case ship
        case bus
        case car
        
        enum Direction: String, Codable {
            case arrival, departure
        }
    }
    
    
    case accomodation
    case transfer(transfer: Transfer, direction: Transfer.Direction)
    case activity(activity: Activity)
    
    enum CodingKeys: CodingKey {
        case accomodation, transfer, activity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        
        switch key {
        case .accomodation:
            self = .accomodation
        case .activity:
            let activity = try container.decode(Activity.self, forKey: .activity)
            self = .activity(activity: activity)
        case .transfer:
            let (transfer, direction): (Transfer, Transfer.Direction) = try container.decodeValues(for: .transfer)
            self = .transfer(transfer: transfer, direction: direction)
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .accomodation:
            try container.encode(true, forKey: .accomodation)
        case .activity(let activity):
            try container.encode(activity, forKey: .activity)
        case .transfer(let transfer, let direction):
            try container.encodeValues(transfer, direction, for: .transfer)
        }
    }
}
