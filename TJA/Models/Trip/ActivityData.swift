//
//  ActivityData.swift
//  TJA
//
//  Created by Miron Rogovets on 15.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

struct ActivityResponse: Decodable {
    let id: Int
    let name: String
    let description: String?
    let startTime: Date?
    let endTime: Date?
    let note: String
    let transferType: String
    let direction: String
    let eventType: String
    let lat: Double
    let lon: Double
    let activityType: String
    
    enum BaseType: String, Decodable {
        case transfer, accommodation, event
    }
    
    enum CodingKeys: CodingKey {
        case id, name, description, startTime, endTime, note, lat, lon
        case activityType, eventType
        case transferType, direction
    }
    
    var activityItem: Activity {
        var type: Activity.ActivityType
        
        if activityType == "transfer" {
            let tr = Activity.Transfer(rawValue: transferType)
            let dir = Activity.Transfer.Direction(rawValue: direction)
            type = .transfer(tr ?? .car, dir ?? .departure)
        } else if activityType == "accommodation" {
            let dir = Activity.Accommodation.Direction(rawValue: direction)
            type = .accommodation(dir ?? .checkin)
        } else {
            let ev = Activity.Event(rawValue: eventType)
            type = .event(ev ?? .fun)
        }
        return Activity(id: id, name: name, description: description,
                 startTime: startTime, endTime: endTime, note: note,
                 location: Location(placeName: name, lat: lat, lon: lon),
                 activityType: type)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .activityType)
        if type == "transfer" {
            self.transferType = try container.decode(String.self, forKey: .transferType)
            self.direction = try container.decode(String.self, forKey: .direction)
            self.eventType = ""
        } else if type == "accommodation" {
            self.transferType = ""
            self.direction = try container.decode(String.self, forKey: .direction)
            self.eventType = ""
        } else {
            self.transferType = ""
            self.direction = ""
            self.eventType = try container.decode(String.self, forKey: .eventType)
        }
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String?.self, forKey: .description)
        self.startTime = try container.decode(Date?.self, forKey: .startTime)
        self.endTime = try container.decode(Date?.self, forKey: .endTime)
        self.note = try container.decode(String.self, forKey: .note)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.activityType = type
    }
}


protocol NewActivityRequest {
    var name: String { get }
    var description: String? { get }
    var startTime: Date? { get }
    var endTime: Date? { get }
    var note: String { get }
    var lat: Double? { get }
    var lon: Double? { get }
    var activityType: String { get }
}

protocol ExistingActivityRequest {
    var id: Int { get }
    var name: String { get }
    var description: String? { get }
    var startTime: Date? { get }
    var endTime: Date? { get }
    var note: String { get }
    var lat: Double? { get }
    var lon: Double? { get }
    var activityType: String { get }
}


enum ActivityRequest {
    
    enum New {
        
        struct Event: NewActivityRequest, Codable {
            let name: String
            let description: String?
            let startTime: Date?
            let endTime: Date?
            let note: String
            let lat: Double?
            let lon: Double?
            let activityType: String
            
            let eventType: String
            
        }
        
        struct Accommodation: NewActivityRequest, Codable {
            let name: String
            let description: String?
            let startTime: Date?
            let endTime: Date?
            let note: String
            let lat: Double?
            let lon: Double?
            let activityType: String
            
            let direction: String
            
        }
        
        struct Transfer: NewActivityRequest, Codable {
            let name: String
            let description: String?
            let startTime: Date?
            let endTime: Date?
            let note: String
            let lat: Double?
            let lon: Double?
            let activityType: String
            
            let direction: String
            let transferType: String
            
        }
        
    }
    
    enum Existing {
        
        struct Event: ExistingActivityRequest, Codable {
            let id: Int
            let name: String
            let description: String?
            let startTime: Date?
            let endTime: Date?
            let note: String
            let lat: Double?
            let lon: Double?
            let activityType: String
            
            let eventType: String
            
        }
        
        struct Accommodation: ExistingActivityRequest, Codable {
            let id: Int
            let name: String
            let description: String?
            let startTime: Date?
            let endTime: Date?
            let note: String
            let lat: Double?
            let lon: Double?
            let activityType: String
            
            let direction: String
            
        }
        
        struct Transfer: ExistingActivityRequest, Codable {
            let id: Int
            let name: String
            let description: String?
            let startTime: Date?
            let endTime: Date?
            let note: String
            let lat: Double?
            let lon: Double?
            let activityType: String
            
            let direction: String
            let transferType: String
            
        }
        
    }
    
}

extension ActivityRequest.New {
    
    static func createRequest(
        for activityType: Activity.ActivityType,
        name: String,
        description: String? = nil,
        startTime: Date? = nil,
        endTime: Date? = nil,
        note: String = "",
        location: Location? = nil
    ) -> NewActivityRequest {
        switch activityType {
        case let .accommodation(direction):
            return Accommodation(
                name: name,
                description: description,
                startTime: startTime,
                endTime: endTime,
                note: note,
                lat: location?.lat,
                lon: location?.lon,
                activityType: activityType.typeName,
                direction: direction.rawValue
            )
        case let .event(event):
            return Event(
                name: name,
                description: description,
                startTime: startTime,
                endTime: endTime,
                note: note,
                lat: location?.lat,
                lon: location?.lon,
                activityType: activityType.typeName,
                eventType: event.rawValue
            )
        case let .transfer(transfer, direction):
            return Transfer(
                name: name,
                description: description,
                startTime: startTime,
                endTime: endTime,
                note: note,
                lat: location?.lat,
                lon: location?.lon,
                activityType: activityType.typeName,
                direction: direction.rawValue,
                transferType: transfer.rawValue
            )
        }
    }
}


extension ActivityRequest.Existing {
    
    static func createRequest(from activity: Activity) -> ExistingActivityRequest {
        switch activity.activityType {
        case let .accommodation(direction):
            return Accommodation(
                id: activity.id,
                name: activity.name,
                description: activity.description,
                startTime: activity.startTime,
                endTime: activity.endTime,
                note: activity.note,
                lat: activity.location?.lat,
                lon: activity.location?.lon,
                activityType: activity.activityType.typeName,
                direction: direction.rawValue
            )
        case let .event(event):
            return Event(
                id: activity.id,
                name: activity.name,
                description: activity.description,
                startTime: activity.startTime,
                endTime: activity.endTime,
                note: activity.note,
                lat: activity.location?.lat,
                lon: activity.location?.lon,
                activityType: activity.activityType.typeName,
                eventType: event.rawValue
            )
        case let .transfer(transfer, direction):
            return Transfer(
                id: activity.id,
                name: activity.name,
                description: activity.description,
                startTime: activity.startTime,
                endTime: activity.endTime,
                note: activity.note,
                lat: activity.location?.lat,
                lon: activity.location?.lon,
                activityType: activity.activityType.typeName,
                direction: direction.rawValue,
                transferType: transfer.rawValue
            )
        }
    }
}


extension ActivityRequest.New {
    
    static func createRequest(
        for transfer: Activity.Transfer,
        with location: Location,
        for time: TimeInterval,
        with startingDate: Date,
        with direction: Activity.Transfer.Direction = .arrival,
        with description: String = ""
    ) -> NewActivityRequest {
        
        return Transfer(
            name: location.placeName,
            description: description,
            startTime: startingDate.addingTimeInterval(time),
            endTime: startingDate.addingTimeInterval(time),
            note: "",
            lat: location.lat,
            lon: location.lon,
            activityType: "transfer",
            direction: direction.rawValue,
            transferType: transfer.rawValue)
    }
    
    static func createRequest(
        for accommodation: AccommodationLocation,
        for time: TimeInterval,
        with startingDate: Date,
        with direction: Activity.Accommodation.Direction = .checkin
    ) -> NewActivityRequest {
        
        return Accommodation(
            name: accommodation.name,
            description: accommodation.description,
            startTime: startingDate.addingTimeInterval(time),
            endTime: startingDate.addingTimeInterval(time),
            note: "",
            lat: accommodation.lat,
            lon: accommodation.lon,
            activityType: "accommodation",
            direction: direction.rawValue
        )
    }
}
