//
//  Event.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


struct Event: Hashable, Codable, Identifiable, Comparable {
    
    let id: Int
    let eventType: EventType
    let name: String
    let note: String
    let startTime: Date
    let endTime: Date
    let location: Location?
    
    var scheduled: Bool {
        return startTime == endTime
    }
    
    var exactTime: Date {
        startTime
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        if !lhs.scheduled && !rhs.scheduled {
            return lhs.endTime < rhs.endTime
        } else {
            return lhs.exactTime < rhs.exactTime
        }
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
        
        
        // TODO: Fill in icons
        var icon: String {
            switch self {
            case .food: return ""
            case .bar: return ""
            case .gallery: return ""
            case .museum: return ""
            case .sightseeing: return ""
            case .fun: return ""
            }
        }
    }
    
    enum Transfer: String, Codable {
        case plane
        case train
        case ship
        case bus
        case car
        
        
        // TODO: Fill in icons
        var icon: String {
            switch self {
            case .plane: return "airplane"
            case .train: return "tram.fill"
            case .ship: return ""
            case .bus: return ""
            case .car: return "car.fill"
            }
        }
    }
    
    
    case accomodation
    case transfer(transfer: Transfer, arrival: Bool)
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
            let (transfer, arrival): (Transfer, Bool) = try container.decodeValues(for: .transfer)
            self = .transfer(transfer: transfer, arrival: arrival)
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
        case .transfer(let transfer, let arrival):
            try container.encodeValues(transfer, arrival, for: .transfer)
        }
    }
    
    
    // TODO: Fill in icons
    var categoryIcon: String {
        switch self {
        case .accomodation: return "bed.double"
        case .activity(let activity): return activity.icon
        case .transfer(let transfer, _): return transfer.icon
        }
    }
    
    // TODO: Fill in icons
    var eventIcon: String {
        switch self {
        case .transfer(let transfer, let arrival):
            switch transfer {
            case .plane: return arrival ? "" : ""
            default: return transfer.icon
            }
        default: return categoryIcon
        }
    }
}
