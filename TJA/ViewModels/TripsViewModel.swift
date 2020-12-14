//
//  TripsViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 12.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

class TripsViewModel: NSObject, ObservableObject, TripService {
    
    var apiSession: APIService
    var cancellationTokens = Set<AnyCancellable>()
    
    @Published var trips = [SwipeableItem<Trip>]()
    
    init(apiService: APIService) {
        self.apiSession = apiService
    }
    
    func loadTrips() {
        let token = self.getTrips().sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- TripList -- Error -- \(err.localizedDescription)")
            case let .success(response):
                if let err = response.getError() {
                    print("DEBUG: -- TripList -- Response error -- \(err.localizedDescription)")
                }
                print("DEBUG: -- TripList -- Success")
                self.trips = response.body?.compactMap { SwipeableItem<Trip>($0.trip) } ?? []
                print(self.trips)
            }
        }
        self.cancellationTokens.insert(token)
    }
    
    func createTrip(name: String, destination: String, startDate: Date, endDate: Date) {
        let trip = TripRequest(
            name: name, destination: destination, startDate: startDate, endDate: endDate
        )
        let token = self.addTrip(trip: trip).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- NewTrip -- Error -- \(err.localizedDescription)")
            case let .success(response):
                if let err = response.getError() {
                    print("DEBUG: -- NewTrip -- Response error -- \(err.localizedDescription)")
                }
                print("DEBUG: -- NewTrip -- Success")
                if let item = response.body {
                    self.trips.append(SwipeableItem<Trip>(item.trip))
                    print(item.trip)
                }
            }
        }
        self.cancellationTokens.insert(token)
    }
    
    func get(by id: Int) {
        print("DEBUG: -- Fetching trip by id = \(id)")
    }
    
    func delete(by id: Int) {
        print("DEBUG: -- Removing trip by id = \(id)")
        let token = self.deleteTrip(id: id).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- DeleteTrip -- Error -- \(err.localizedDescription)")
            case let .success(response):
                if let err = response.getError() {
                    print("DEBUG: -- DeleteTrip -- Response error -- \(err.localizedDescription)")
                }
                print("DEBUG: -- DeleteTrip -- Success")
                
            }
        }
        self.cancellationTokens.insert(token)
        self.trips.removeAll(where: { $0.id == id })
    }
    
    var hasUpcoming: Bool {
        return upcoming.count > 0
    }
    
    var hasFinished: Bool {
        return finished.count > 0
    }
    
    var upcoming: [SwipeableItem<Trip>] {
        return trips.filter({!$0.item.isFinished}).sorted(by: {$0.item.startDate < $1.item.startDate})
    }
    
    var finished: [SwipeableItem<Trip>] {
        return trips.filter({$0.item.isFinished}).sorted(by: {$0.item.startDate > $1.item.startDate})
    }
}
