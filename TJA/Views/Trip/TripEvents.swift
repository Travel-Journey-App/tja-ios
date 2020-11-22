//
//  TripEvents.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct TripEvents: View {
    
    enum Tab: Int {
        case events, map
        
        var icon: String {
            switch self {
            case .events: return "list.bullet"
            case .map: return "mappin.circle"
            }
        }
    }
    
    @State var selectedTab = Tab.events
    
    var tripname = ""
    var location: Location?
    
    var body: some View {
        VStack {
            // Segment control
            Picker("", selection: $selectedTab) {
                Image(systemName: Tab.events.icon)
                    .tag(Tab.events)
                    .frame(width: 24, height: 24, alignment: .center)
                Image(systemName: Tab.map.icon)
                    .tag(Tab.map)
                    .frame(width: 24, height: 24, alignment: .center)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)
            .padding(.top, 10)
            
            // Content
            contentSection
        }
        .navigationBarTitle(Text(tripname.uppercased()), displayMode: .inline)
    }
    
    var contentSection: some View {
        switch self.selectedTab {
        case .events: return DaysContainer().toAnyView()
        case .map: return MapContainer(location: location).toAnyView()
        }
    }
}

struct TripEvents_Previews: PreviewProvider {
    static var previews: some View {
        TripEvents(location: mockTripLocation)
    }
}
