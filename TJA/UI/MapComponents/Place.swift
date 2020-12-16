//
//  Place.swift
//  TJA
//
//  Created by Miron Rogovets on 15.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import MapKit

protocol PlaceItem {
    var locationDetails: Location { get }
    var icon: UIImage? { get }
}

class Place<T: PlaceItem & Comparable>: NSObject, MKAnnotation, Comparable {
    
    static func < (lhs: Place, rhs: Place) -> Bool {
        return lhs.item < rhs.item
    }
    
    
    let item: T
    
    var title: String? {
        item.locationDetails.placeName
    }
    
    init(_ item: T) {
        self.item = item
    }
    
    var coordinate: CLLocationCoordinate2D {
        item.locationDetails.coordinate
    }
}
