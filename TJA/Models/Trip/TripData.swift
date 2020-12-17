//
//  TripData.swift
//  TJA
//
//  Created by Miron Rogovets on 12.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

struct TripResponse: Codable {
    let id: Int
    let name: String
    let destination: String
    let startDate: Date
    let endDate: Date
    let cover: String?
    let days: [TripDay]
    let lat: Double
    let lon: Double
    
    var trip: Trip {
        Trip(
            id: id,
            image: URL(string: cover ?? ""),
            name: name,
            startDate: startDate,
            endDate: endDate,
            location: Location(placeName: destination, lat: lat, lon: lon),
            days: days
        )
    }
}

struct TripRequest: Codable {
    let name: String
    let destination: String
    let startDate: Date
    let endDate: Date
    let lat: Double
    let lon: Double
}

struct TripUpdateRequest: Encodable {
    let id: Int
    let name: String
    let destination: String
    let startDate: Date
    let endDate: Date
    let cover: String?
    let days: [TripDayRequest]
    let lat: Double
    let lon: Double
}

struct TripDayRequest: Encodable {
    let id: Int
    let orderInTrip: Int
    let activities: [ActivityResponse]
    
    enum CodingKeys: CodingKey {
        case id, orderInTrip, activities
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(orderInTrip, forKey: .orderInTrip)
        let activitiesContainer = container.superEncoder(forKey: .activities)
        try activities.encode(to: activitiesContainer)
    }
}

extension TripDayRequest {
    init(_ tripDay: TripDay) {
        self.init(
            id: tripDay.id,
            orderInTrip: tripDay.orderInTrip,
            activities: tripDay.activities.compactMap { ActivityResponse($0.item) }
        )
    }
}

extension ActivityResponse {
    init(_ activity: Activity) {
        
        let trans: String
        let event: String
        let dir: String
        
        switch activity.activityType {
        case let .accommodation(direction):
            dir = direction.rawValue
            event = ""
            trans = ""
        case let .event(ev):
            dir = ""
            event = ev.rawValue
            trans = ""
        case let .transfer(transfer, direction):
            dir = direction.rawValue
            event = ""
            trans = transfer.rawValue
        }
        
        self.id = activity.id
        self.name = activity.name
        self.description = activity.description
        self.startTime = activity.startTime
        self.endTime = activity.endTime
        self.note = activity.note
        self.transferType = trans
        self.direction = dir
        self.eventType = event
        self.lat = activity.location?.lat ?? Double()
        self.lon = activity.location?.lon ?? Double()
        self.activityType = activity.activityType.typeName
    }
}

extension TripUpdateRequest {
    static func create(from trip: Trip) -> TripUpdateRequest? {
        if let location = trip.location {
            return TripUpdateRequest(
                id: trip.id,
                name: trip.name,
                destination: location.placeName,
                startDate: trip.startDate,
                endDate: trip.endDate,
                cover: trip.image?.absoluteString,
                days: trip.days.compactMap { TripDayRequest($0) },
                lat: location.lat,
                lon: location.lon
            )
        }
        return nil
    }
}
