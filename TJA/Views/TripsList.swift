//
//  TripsList.swift
//  TJA
//
//  Created by Miron Rogovets on 10.11.2020.
//

import SwiftUI

struct TripsList: View {
    
    var tripname = ""
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.blue
            Text("Trip item: \(tripname)")
        }
        .navigationBarTitle(Text(tripname.uppercased()), displayMode: .inline)
    }
}

struct TripsList_Previews: PreviewProvider {
    static var previews: some View {
        TripsList()
    }
}
