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
    
    init(trip: Trip, apiService: APIService) {
        self._trip = .init(initialValue: trip)
        self.apiSession = apiService
    }
    
    var daysCount: Int {
        trip.days.count
    }
    
    func filter(by day: Int?) -> [Activity] {
        if let day = day, let index = getIndex(for: day)  {
            return trip.days[index].activities
        } else {
            return trip.days.flatMap(\.activities)
        }
    }
    
    func create(in day: Int) {
        let request = ActivityRequest.New.createRequest(for: .event(.bar), name: "test")
        self.add(activity: request, to: trip.id, on: day).sinkToResult { result in
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
           let activityIndex = getActivityIndex(for: id, with: day) {
            self.trip.days[dayIndex].activities[activityIndex] = activity
            self.trip.days[dayIndex].activities.sort()
        }
    }
    
    private func append(_ activity: Activity, to day: Int) {
        if let dayIndex = getIndex(for: day) {
            self.trip.days[dayIndex].activities.append(activity)
            self.trip.days[dayIndex].activities.sort()
        }
    }
    
    private func getIndex(for id: Int) -> Int? {
        return self.trip.days.firstIndex(where: { $0.id == id })
    }
    
    private func getActivityIndex(for id: Int, with dayIndex: Int) -> Int? {
        return self.trip.days[dayIndex].activities.firstIndex(where: {$0.id == id})
    }
}
