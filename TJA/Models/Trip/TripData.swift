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
    
    var trip: Trip {
        Trip(
            id: id,
            image: URL(string: cover ?? ""),
            name: name,
            startDate: startDate,
            endDate: endDate,
            location: nil
        )
    }
}

struct TripRequest: Codable {
    let name: String
    let destination: String
    let startDate: Date
    let endDate: Date
    let days: [TripDay]
}
