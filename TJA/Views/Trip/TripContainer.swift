//
//  TripContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct TripContainer: View {
    
    @EnvironmentObject var eventService: EventService
    var tripname = ""
    var location: Location?
    
    var body: some View {
        SegmentedContainer(
            list: { DaysContainer() },
            map: { MapContainer(location: location) }
        )
        .navigationBarTitle(Text(tripname.uppercased()), displayMode: .inline)
    }
}

struct TripContainer_Previews: PreviewProvider {
    static var previews: some View {
        TripContainer(location: Mockup.Locations.mockTripLocation)
            .environmentObject(EventService())
    }
}
