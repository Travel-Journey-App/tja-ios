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
    @State var selectedItem: SwipeableItem<Trip>? = nil
    @EnvironmentObject var viewModel: TripsViewModel
    
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
                                            tripname: trip.item.name
                                        )
                                        .environmentObject(
                                            ActivityViewModel(
                                                trip: trip.item,
                                                apiService: APISession.shared
                                            )
                                        )
                                        .environmentObject(PopupViewModel())
                                    ) {
                                        Swipeable(
                                            self.$viewModel.trips[getIndex(id: trip.id)],
                                            onSwiped: {
                                                print("DEBUG: -- onSwiped tirggered for -- \(trip.id)")
                                                self.delete(by: trip.id)
                                            },
                                            onDeleteTapped: { item in
                                                self.selectedItem = item
                                            }) { trip in
                                            TripCell(trip: trip) { name in
                                                self.viewModel.update(trip: trip, with: name)
                                            }
                                        }
                                        
                                    }.buttonStyle(FlatLinkStyle())
                                }
                            }.padding(.vertical, 24)
                        }
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.hideKeyboard()
                        }
                    } else {
                        Spacer()
                        placeholder
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
        }
        .onAppear(perform: self.viewModel.loadTrips)
        .alert(item: $selectedItem) { item in
            Alert(
                title: Text("Do you want to delete item?"),
                message: Text("\(item.item.name)"),
                primaryButton: .destructive(Text("Yes")) {
                    print("Delete")
                    self.selectedItem = nil
                    self.delete(by: item.item.id)
                }, secondaryButton: .cancel(Text("No")))
        }
    }
    
    var placeholder: some View {
        if viewModel.loadingState.isLoading {
            return ActivityIndicatorView().toAnyView()
        } else {
            return Text("You don't have any \(selectedTab.title) trips")
                .font(.system(size: 20))
                .foregroundColor(.mainRed)
                .toAnyView()
        }
    }
    
    private func delete(by id: Int) {
        self.viewModel.delete(by: id)
    }
    
    private var hasTrips: Bool {
        switch self.selectedTab {
        case .future: return self.viewModel.hasUpcoming
        case .past: return self.viewModel.hasFinished
        }
    }
    
    private var tripItems: [SwipeableItem<Trip>] {
        switch self.selectedTab {
        case .future: return self.viewModel.upcoming
        case .past: return self.viewModel.finished
        }
    }
    
    private func getIndex(id: Int) -> Int {
        print("DEBUG: -- Getting index = \(id)")
        return viewModel.trips.firstIndex { (item) -> Bool in
            return id == item.id
        } ?? 0
    }
}

struct MyTrips_Previews: PreviewProvider {
    static var previews: some View {
        MyTrips().environmentObject(TripsViewModel(apiService: APISession.shared))
    }
}
