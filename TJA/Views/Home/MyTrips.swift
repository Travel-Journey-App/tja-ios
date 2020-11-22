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
                                        destination: TripEvents(
                                            tripname: trip.name,
                                            location: trip.location
                                        )) {
                                        TripCell(trip: trip)
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
        }.onAppear(perform: self.tripService.loadTrips)
    }
    
    
    private func delete(at offsets: IndexSet) {
        self.tripService.delete(at: offsets)
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
}

struct MyTrips_Previews: PreviewProvider {
    static var previews: some View {
        MyTrips().environmentObject(TripService.shared)
    }
}
