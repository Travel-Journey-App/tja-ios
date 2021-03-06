//
//  PlaceAnnotation.swift
//  TJA
//
//  Created by Miron Rogovets on 15.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import MapKit

class PlaceAnnotation<T: PlaceItem & Comparable>: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = annotation as? Place<T> else { return }
            displayPriority = .defaultHigh
            markerTintColor = UIColor(named: "MainRed")
            glyphImage = annotation.item.icon
            animatesWhenAdded = true
        }
    }
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "place"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
