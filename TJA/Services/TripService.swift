//
//  TripService.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//

import Foundation


class TripService: NSObject, ObservableObject {
    
    @Published var trips: [Trip] = []
    
    static let shared = TripService()
    
    func loadTrips() {
        var trips = generateMockupTrips()
        self.trips = trips
    }
    
    func saveTrip(name: String, startDate: Date, endDate: Date) {
        let imgUrl = URL(string: "https://images.unsplash.com/photo-1543988884-c01cfa7b41c2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1482&q=80")
        let trip = Trip(id: trips.count, image: imgUrl, name: name, startDate: startDate, endDate: endDate)
        self.trips.append(trip)
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


func generateMockupTrips() -> [Trip] {
    let now = Date()
    var trips = [Trip]()
    
    let day = 60 * 60 * 24 as TimeInterval
    let week = day * 7 as TimeInterval
    
    trips.append(
        Trip(
            id: 0,
            image: URL(string: "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80"),
            name: "London",
            startDate: now.addingTimeInterval(-day*2),
            endDate: now.addingTimeInterval(-day)
        )
    )
    trips.append(
        Trip(
            id: 1,
            image: URL(string: "https://images.unsplash.com/photo-1495542779398-9fec7dc7986c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=968&q=80"),
            name: "Moscow",
            startDate: now.addingTimeInterval(-week*2),
            endDate: now.addingTimeInterval(-week)
        )
    )
    trips.append(
        Trip(
            id: 2,
            image: URL(string: "https://images.unsplash.com/photo-1541503506238-58dbe11ef244?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80"),
            name: "Brussels",
            startDate: now.addingTimeInterval(-day),
            endDate: now.addingTimeInterval(day*3)
        )
    )
    trips.append(
        Trip(
            id: 3,
            image: URL(string: "https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=762&q=80"),
            name: "Tokyo",
            startDate: now.addingTimeInterval(week*2),
            endDate: now.addingTimeInterval(week*2 + day*4)
        )
    )
    trips.append(
        Trip(
            id: 4,
            image: URL(string: "https://images.unsplash.com/photo-1601751664209-be452817a8ce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80"),
            name: "NY",
            startDate: now.addingTimeInterval(week*5),
            endDate: now.addingTimeInterval(week*6)
        )
    )
    trips.append(
        Trip(
            id: 5,
            image: URL(string: "https://images.unsplash.com/photo-1601907449390-a10b97d6368a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1051&q=80"),
            name: "Okinawa",
            startDate: now.addingTimeInterval(week*6),
            endDate: now.addingTimeInterval(week*7)
        )
    )
    
    return trips
}
