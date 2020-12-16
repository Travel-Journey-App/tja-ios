//
//  Constants.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


enum Constants {
    
    enum Text {
        
        static let supportInfoText = "You can forvard to mytrips.tech@trip.net confirmations about tickets, hotels and other\u{00a0}events in order to automatically fill in all\u{00a0}your\u{00a0}activities"
        
    }
    static let placeAnnotationReuseId = "placeAnnotation"
    static let defaultLocation = Location(placeName: "Tokyo", lat: 35.011665, lon: 135.768326)
    static let mockActivity = Activity(id: -1, name: "Ooops...", description: "Something went wrong",
                                       startTime: nil, endTime: nil, note: "", location: nil, activityType: .event(.fun))
}
