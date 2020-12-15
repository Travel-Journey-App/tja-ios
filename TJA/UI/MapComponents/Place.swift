//
//  Place.swift
//  TJA
//
//  Created by Miron Rogovets on 15.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import MapKit

class Place: NSObject, Decodable, MKAnnotation, Comparable {
    
    static func < (lhs: Place, rhs: Place) -> Bool {
        return lhs.activity < rhs.activity
    }
    
    
    let activity: Activity
    
    var title: String? {
        activity.name
    }
    
    init?(_ activity: Activity) {
        guard let _ = activity.location else { return nil }
        self.activity = activity
    }
    
    var coordinate: CLLocationCoordinate2D {
        activity.location?.coordinate ?? Constants.defaultLocation.coordinate
    }
}
