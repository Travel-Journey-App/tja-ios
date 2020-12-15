//
//  MapContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct MapContainer: View {
    
    enum DataSource: Identifiable {
        case activity, suggestions
        
        var id: Int {
            hashValue
        }
    }
    
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var activityViewModel: ActivityViewModel
    
    @State var selected: Place? = nil
    
    var location: Location? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(
                places: $activityViewModel.filtered,
                selectedPlace: $selected.didSet { place in
                    if let place = place {
                        print("DEBUG: -- Selected place: \(place.activity)")
                    }
                },
                tripLocation: location?.coordinate
            ).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // Filters
                MapFilters(daysCount: activityViewModel.daysCount, onFilterChanged: applyFilters)
                Spacer()
                
                // Current location button
                HStack {
                    Spacer()
                    Button(action: {
                        print("DEBUG: -- Current location tapped")
                        self.locationService.userTrackingMode = .follow
                    }) {
                        Image(systemName: "location.fill")
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .buttonStyle(CircleButtonStyle())
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 30)
            .padding(.top, 20)
        }
        .onAppear(perform: self.locationService.checkPermissions)
        .alert(isPresented: $locationService.servicesDisabled) {
            Alert(title: Text("Please Enable Location Access In Settings"))
        }.onAppear(perform: loadEvents)
    }
    
    private func applyFilters(_ day: Int?) {
        self.activityViewModel.filter(by: day)
    }
    
    private func loadEvents() {
         self.activityViewModel.filter(by: nil)
    }
}

struct MapContainer_Previews: PreviewProvider {
    static var previews: some View {
        MapContainer()
    }
}
