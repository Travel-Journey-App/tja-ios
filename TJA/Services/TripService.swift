//
//  TripService.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


class TripService: NSObject, ObservableObject {
    
    @Published var trips: [Trip] = []
    
    static let shared = TripService()
    
    func loadTrips() {
        var trips = Mockup.Trips.generateMockupTrips()
        self.trips = trips
    }
    
    func saveTrip(name: String, destination: String, startDate: Date, endDate: Date) {
        let imgUrl = URL(string: "https://images.unsplash.com/photo-1543988884-c01cfa7b41c2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1482&q=80")
        let trip = Trip(
            id: trips.count,
            image: imgUrl,
            name: name,
            startDate: startDate,
            endDate: endDate,
            location: Location(placeName: destination, lat: 40.71, lon: -74)
        )
        self.trips.append(trip)
    }
    
    func delete(at offsets: IndexSet) {
        print("DEBUG: -- Removing trips at \(offsets)")
        self.trips.remove(atOffsets: offsets)
    }
    
    var hasUpcoming: Bool {
        return upcoming.count > 0
    }
    
    var upcoming: [Trip] {
        return trips.filter({!$0.isFinished}).sorted(by: {$0.startDate < $1.startDate})
    }
    
    var finished: [Trip] {
        return trips.filter({$0.isFinished}).sorted(by: {$0.startDate > $1.startDate})
    }
    
    var hasFinished: Bool {
        return finished.count > 0
    }
}
