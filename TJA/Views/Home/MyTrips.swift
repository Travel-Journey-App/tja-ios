//
//  MyTrips.swift
//  TJA
//
//  Created by Miron Rogovets on 11.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct MyTrips: View {
    
    @State var selectedTab = Tab.future
    @EnvironmentObject var tripService: TripService
    @State var swipeableItems: [SwipeableItem<Trip>] = []
    
    enum Tab: Int {
        case future, past
        
        var title: String {
            switch self {
            case .future: return "upcoming"
            case .past: return "past"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Backgroubd items
                VStack {
                    // Segment control
                    Picker("", selection: $selectedTab) {
                        Text(Tab.future.title.uppercased()).tag(Tab.future).font(.title)
                        Text(Tab.past.title.uppercased()).tag(Tab.past).font(.title)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 10)
                    
                    // Trips list
                    if hasTrips {
                        ScrollView(.vertical) {
                            VStack(alignment: .center, spacing: 24) {
                                ForEach(tripItems) { trip in
                                    NavigationLink(
                                        destination: TripContainer(
                                            tripname: trip.name,
                                            location: trip.location
                                        ).environmentObject(EventService(start: trip.startDate))
                                    ) {
                                        Swipeable(
                                            $swipeableItems[getIndex(id: trip.id)],
                                            onSwiped: {
                                                print("DEBUG: -- onSwiped tirggered for -- \(trip.id)")
                                                self.delete(by: trip.id)
                                            }) { trip in
                                            TripCell(trip: trip)
                                        }
                                        
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }.padding(.vertical, 24)
                        }
                        .padding(.horizontal, 10)
                    } else {
                        Spacer()
                        Text("You don't have any \(selectedTab.title) trips")
                            .font(.system(size: 20))
                            .foregroundColor(Color("MainRed"))
                        Spacer()
                    }
                }
                
                // "+" button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: CreateTrip()) {
                            Image(systemName: "plus")
                                .frame(width: 24, height: 24, alignment: .center)
                        }
                        .buttonStyle(CircleButtonStyle())
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 48)
            }
            .navigationBarTitle(Text("My trips".uppercased()))
        }.onAppear {
            self.tripService.loadTrips(onLoaded: self.loadSwipeable(with:))
        }
    }
    
    
    private func loadSwipeable(with trips: [Trip]) {
        self.swipeableItems = trips.compactMap {
            return SwipeableItem<Trip>(item: $0, offset: 0, isSwiped: false)
        }
    }
    
    private func delete(by id: Int) {
        print("DEBUG: -- Before removal Swipeable: \(swipeableItems.count)")
        self.tripService.delete(by: id)
        self.loadSwipeable(with: self.tripService.trips)
        print("DEBUG: -- After removal Swipeable: \(swipeableItems.count)")
    }
    
    private var hasTrips: Bool {
        switch self.selectedTab {
        case .future: return self.tripService.hasUpcoming
        case .past: return self.tripService.hasFinished
        }
    }
    
    private var tripItems: [Trip] {
        switch self.selectedTab {
        case .future: return self.tripService.upcoming
        case .past: return self.tripService.finished
        }
    }
    
    private func getIndex(id: Int) -> Int {
        print("DEBUG: -- Getting index = \(id)")
        return swipeableItems.firstIndex { (item) -> Bool in
            return id == item.id
        } ?? 0
    }
}

struct MyTrips_Previews: PreviewProvider {
    static var previews: some View {
        MyTrips().environmentObject(TripService.shared)
    }
}
