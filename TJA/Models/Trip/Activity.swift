//
//  Event.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


struct Activity: Codable, Hashable, Identifiable, Comparable {

    enum ActivityType: Codable {
        case event(Event)
        case accommodation(Accommodation.Direction)
        case transfer(Transfer, Transfer.Direction)
        
        var typeName: String {
            switch self {
            case .event: return "event"
            case .accommodation: return "accommodation"
            case .transfer: return "transfer"
            }
        }
        
        func exactTimeString(time: Date) -> String {
            switch self {
            case let .accommodation(direction):
                return "\(direction.rawValue): \(time.localizedTimeString())"
            default:
                return dateTimeFormatter.string(from: time)
            }
        }
        
        enum CodingKeys: CodingKey {
            case accommodation, transfer, event
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let key = container.allKeys.first
            
            switch key {
            case .event:
                let event = try container.decode(Event.self, forKey: .event)
                self = .event(event)
            case .accommodation:
                let direction = try container.decode(Accommodation.Direction.self, forKey: .accommodation)
                self = .accommodation(direction)
            case .transfer:
                let (transfer, direction): (Transfer, Transfer.Direction) = try container.decodeValues(for: .transfer)
                self = .transfer(transfer, direction)
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
            case let .accommodation(direction):
                try container.encode(direction, forKey: .accommodation)
            case let .event(event):
                try container.encode(event, forKey: .event)
            case let .transfer(transfer, direction):
                try container.encodeValues(transfer, direction, for: .transfer)
            }
        }
    }

    enum Accommodation {

        enum Direction: String, Codable {
            case checkin = "check-in"
            case checkout = "check-out"

            var strValue: String {
                rawValue.capitalizedFirstLetter()
            }
        }
    }

    enum Event: String, Codable {
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

    let id: Int
    let name: String
    let description: String?
    let startTime: Date?
    let endTime: Date?
    let note: String
    let location: Location?
    let activityType: ActivityType

    var scheduled: Bool {
        !withoutTime && startTime == endTime
    }

    var withoutTime: Bool {
        startTime == nil && endTime == nil
    }
    
    var exactTime: Date? {
        startTime
    }

    var timeString: String {
        if withoutTime { return "Open" }
        
        if scheduled, let time = exactTime {
            return activityType.exactTimeString(time: time)
        }
        if let end = endTime, let start = startTime {
            return "Open: \(start.localizedTimeString()) - \(end.localizedTimeString())"
        }
        return "Closed"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: Activity, rhs: Activity) -> Bool {
        
        if rhs.withoutTime { return false }
        if lhs.withoutTime { return true }
        
        if lhs.scheduled && rhs.scheduled, let l = lhs.exactTime, let r = rhs.exactTime {
            return l < r
        }
        
        if !lhs.scheduled && !rhs.scheduled, let l = lhs.exactTime, let r = rhs.exactTime {
            if l == r, let ll = lhs.endTime, let rr = rhs.endTime {
                return ll < rr
            }
            return l < r
        }
        if let l = lhs.exactTime, let r = rhs.exactTime {
            return l < r
        }
        return true
    }
}
