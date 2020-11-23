//
//  MockupData.swift
//  TJA
//
//  Created by Miron Rogovets on 23.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


enum Mockup {
    
    static let hour = 60 * 60 as TimeInterval
    static let day = 60 * 60 * 24 as TimeInterval
    static let week = day * 7 as TimeInterval
    
    static let images = [
        URL(string: "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80"),
        URL(string: "https://images.unsplash.com/photo-1495542779398-9fec7dc7986c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=968&q=80"),
        URL(string: "https://images.unsplash.com/photo-1541503506238-58dbe11ef244?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80"),
        URL(string: "https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=762&q=80"),
        URL(string: "https://images.unsplash.com/photo-1601751664209-be452817a8ce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80"),
        URL(string: "https://images.unsplash.com/photo-1601907449390-a10b97d6368a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1051&q=80"),
    ]
    
    static let dates = [
        (-day*2, -day),
        (-week*2, -week),
        (-day, day*3),
        (week*2, week*2 + day*4),
        (week*5, week*6),
        (week*6, week*7)
    ]
    
    static let names = [
        "London",
        "Moscow",
        "Brussels",
        "Tokyo",
        "NY",
        "Okinawa"
    ]
    
    enum Trips {
        
        static func generateMockupTrips() -> [Trip] {
            let now = Date()
            var trips = [Trip]()
            
            for i in 0..<dates.count {
                trips.append(
                    Trip(id: i, image: images[i], name: names[i],
                         startDate: now.addingTimeInterval(dates[i].0),
                         endDate: now.addingTimeInterval(dates[i].1),
                         location: Locations.mockTripLocation)
                )
            }
            
            return trips
        }
    }
    
    enum Events {
        
        static func generateDays(numberOfDays: Int = 5, start date: Date) -> [TripDay] {
            var days = [TripDay]()
            
            for i in 0..<numberOfDays {
                days.append(TripDay(id: i, number: i, events: generateEvents(dayNumber: i, timeRef: date.startOf(.day))))
            }
            
            return days
        }
        
        static func generateEvents(dayNumber: Int = 0, timeRef: Date = Date()) -> [Event] {
            var events = [Event]()
            
            switch dayNumber {
            case 0:
                let types: [EventType] = [
                    .transfer(transfer: .plane, direction: .arrival),
                    .activity(activity: .food),
                    .accomodation,
                    .activity(activity: .sightseeing)
                ]
                let names = ["NY Airport", "Hard Rock Cafe", "Ritz Hotel", "Central Park"]
                let times: [Date] = [
                    timeRef.addingTimeInterval(hour*12),
                    timeRef.addingTimeInterval(hour*14),
                    timeRef.addingTimeInterval(hour*15),
                    timeRef.addingTimeInterval(hour*16 + hour / 2)
                ]
                for i in 0..<types.count {
                    events.append(Event(id: i, eventType: types[i], name: names[i], note: "", time: times[i],
                                        location: Mockup.Locations.eventLocations[names[i]]))
                }
            case 2:
                let types: [EventType] = [
                    .activity(activity: .museum),
                    .activity(activity: .bar)
                ]
                let names = ["Museum of modern art", "Local pub"]
                let times: [Date] = [
                    timeRef.addingTimeInterval(hour*12),
                    timeRef.addingTimeInterval(hour*16)
                ]
                for i in 0..<types.count {
                    events.append(Event(id: i, eventType: types[i], name: names[i], note: "", time: times[i],
                                        location: Mockup.Locations.eventLocations[names[i]]))
                }
            case 4:
                let types: [EventType] = [
                    .activity(activity: .food),
                    .transfer(transfer: .car, direction: .departure),
                    .transfer(transfer: .plane, direction: .departure)
                ]
                let names = ["Burger Heroes", "Taxi transfer", "NY Airport"]
                let times: [Date] = [
                    timeRef.addingTimeInterval(hour*10),
                    timeRef.addingTimeInterval(hour*12 + hour/2),
                    timeRef.addingTimeInterval(hour*15)
                ]
                for i in 0..<types.count {
                    events.append(Event(id: i, eventType: types[i], name: names[i], note: "", time: times[i],
                                        location: Mockup.Locations.eventLocations[names[i]]))
                }
            default:
                events.append(
                    Event(id: 0, eventType: .activity(activity: .fun),
                        name: "Party", note: "Some notes", time: timeRef.addingTimeInterval(hour*9), location: nil))
            }
            
            return events
        }
    }
    
    enum Locations {
        static let mockTripLocation = Location(placeName: "New York", lat: 40.71, lon: -74)
        
        static let eventLocations: [String: Location] = [
            "NY Airport"           : Location(placeName: "NY Airport",           lat: 40.6413111, lon: -73.7781391),
            "Hard Rock Cafe"       : Location(placeName: "Hard Rock Cafe",       lat: 40.8285243, lon: -73.9260199),
            "Holiday Inn"          : Location(placeName: "Holiday Inn",          lat: 40.7961708, lon: -73.466321014647),
            "Central Park"         : Location(placeName: "Central Park" ,        lat: 40.7828647, lon: -73.9653551),
            "Museum of modern art" : Location(placeName: "Museum of modern art", lat: 40.7616124, lon: -73.9774991821081),
            "Local pub"            : Location(placeName: "Local pub",            lat: 40.7573539, lon: -73.9835914135406),
            "Burger Heroes"        : Location(placeName: "Burger Heroes",        lat: 40.7274755, lon: -73.9834679),
            "Taxi transfer"        : Location(placeName: "Holiday Inn",          lat: 40.7961708, lon: -73.466321014647),
        ]
    }
}
