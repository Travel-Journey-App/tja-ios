//
//  Location.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Hashable, Codable, Equatable {
    let placeName: String
    let lat: Double
    let lon: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

struct PlaceLocation: Hashable, Codable, Equatable {
    let lat: Double
    let lon: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

struct CityResponse: Codable {
    let cityName: String
    let lat: Double
    let lon: Double
    
    var location: Location {
        Location(placeName: cityName.capitalizedFirstLetter(), lat: lat, lon: lon)
    }
}
