//
//  ActivityViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 15.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

class ActivityViewModel: NSObject, ObservableObject, ActivityService {
    
    var apiSession: APIService
    var cancellationTokens = Set<AnyCancellable>()
    
    @Published var trip: Trip
    @Published var active: Int = -1
    @Published var filtered: [Activity] = []
    
    init(trip: Trip, apiService: APIService) {
        self._trip = .init(initialValue: trip)
        self.apiSession = apiService
    }
    
    var daysCount: Int {
        trip.days.count
    }
    
    var activeDayNumber: Int? {
        active > -1 ? trip.days[active].orderInTrip : nil
    }
    
    var activeDayIndex: Int? {
        active > -1 ? trip.days[active].id : nil
    }
    
    var startDate: Date {
        trip.startDate
    }
    
    func resetSwipes() {
        for i in 0..<trip.days.count {
            for j in 0..<trip.days[i].activities.count {
                trip.days[i].activities[j].isSwiped = false
                trip.days[i].activities[j].offset = 0
            }
        }
    }
    
    func filter(by day: Int?) {
        if let day = day, day < trip.days.count /*, let index = getIndex(for: day)*/  {
            filtered = trip.days[day].activities.compactMap { $0.item }
        } else {
            filtered = trip.days.flatMap(\.activities).compactMap { $0.item }
        }
    }
    
    func sort() {
        for i in 0..<trip.days.count {
            self.trip.days[i].activities.sort(by: { $0.item < $1.item })
        }
    }
    
    func create(_ activity: NewActivityRequest, in day: Int, onSuccess: (() -> ())? = nil) {
        self.add(activity: activity, to: trip.id, on: day).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- NewActivity -- Error -- \(err.localizedDescription)")
            case let .success(response):
                if let err = response.getError() {
                    print("DEBUG: -- NewActivity -- Response error -- \(err.localizedDescription)")
                }
                print("DEBUG: -- NewActivity -- Success")
                if let item = response.body {
                    // append to day
                    self.append(item.activityItem, to: day)
                    onSuccess?()
                }
            }
        }.store(in: &cancellationTokens)
    }
    
    func update(_ activity: Activity, in day: Int) {
        let request = ActivityRequest.Existing.createRequest(from: activity)
        self.update(activity: request, in: trip.id, on: day).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- NewActivity -- Error -- \(err.localizedDescription)")
            case let .success(response):
                if let err = response.getError() {
                    print("DEBUG: -- NewActivity -- Response error -- \(err.localizedDescription)")
                }
                print("DEBUG: -- NewActivity -- Success")
                if let item = response.body {
                    // update in day
                    self.replace(item.activityItem, by: item.id, in: day)
                }
            }
        }.store(in: &cancellationTokens)
    }
    
    func delete(_ activity: Activity, in day: Int) {
        let request = ActivityRequest.Existing.createRequest(from: activity)
        
        self.remove(by: request.id, in: day)
        
        self.delete(activity: request, from: trip.id, on: day).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- NewActivity -- Error -- \(err.localizedDescription)")
            case let .success(response):
                if let err = response.getError() {
                    print("DEBUG: -- NewActivity -- Response error -- \(err.localizedDescription)")
                }
                print("DEBUG: -- NewActivity -- Success")
//                self.remove(by: request.id, in: day)
            }
        }.store(in: &cancellationTokens)
    }
    
    private func remove(by id: Int, in day: Int) {
        if let dayIndex = getIndex(for: day) {
            self.trip.days[dayIndex].activities.removeAll(where: { $0.id == id })
        }
    }
    
    private func replace(_ activity: Activity, by id: Int, in day: Int) {
        if let dayIndex = getIndex(for: day),
           let activityIndex = getActivityIndex(for: id, with: dayIndex) {
            self.trip.days[dayIndex].activities[activityIndex] = .init(item: activity, offset: 0, isSwiped: false)
            self.trip.days[dayIndex].activities.sort(by: { $0.item < $1.item })
        }
    }
    
    private func append(_ activity: Activity, to day: Int) {
        if let dayIndex = getIndex(for: day) {
            self.trip.days[dayIndex].activities.append(.init(item: activity, offset: 0, isSwiped: false))
            self.trip.days[dayIndex].activities.sort(by: { $0.item < $1.item })
        }
    }
    
    private func getIndex(for id: Int) -> Int? {
        return self.trip.days.firstIndex(where: { $0.id == id })
    }
    
    private func getIndex(by number: Int) -> Int? {
        return self.trip.days.firstIndex(where: { $0.orderInTrip == number })
    }
    
    private func getActivityIndex(for id: Int, with dayIndex: Int) -> Int? {
        return self.trip.days[dayIndex].activities.firstIndex(where: {$0.id == id})
    }

    func getMagicTrip(currentTrip: Trip) {
            let trip = TripRequest(
                name: currentTrip.name,
                destination: currentTrip.destination
                startDate: currentTrip.startDate
                endDate: currentTrip.endDate
                lat: currentTrip.lat,
                lon: currentTrip.lon,
                days: currentTrip.days
            )
            let token = self.magic(trip: trip).sinkToResult { result in
                switch result {
                case let .failure(err):
                    print("DEBUG: -- MagicTrip -- Error -- \(err.localizedDescription)")
                case let .success(response):
                    if let err = response.getError() {
                        print("DEBUG: -- MagicTrip -- Response error -- \(err.localizedDescription)")
                    }
                    print("DEBUG: -- MagicTrip -- Success")
                    if let item = response.body {
                        self.trip = SwipeableItem<Trip>(item.trip)
                        print(item.trip)
                    }
                }
            }
            self.cancellationTokens.insert(token)
        }
}
