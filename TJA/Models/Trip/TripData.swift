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
    let days: [TripDay]
}
