//
//  TripContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct TripContainer: View {
    
    @EnvironmentObject var viewModel: ActivityViewModel
    var tripname = ""
    
    var body: some View {
        SegmentedContainer(
            list: { DaysContainer() },
            map: { MapContainer(location: viewModel.trip.location) }
        )
        .navigationBarTitle(Text(tripname.uppercased()), displayMode: .inline)
    }
}
