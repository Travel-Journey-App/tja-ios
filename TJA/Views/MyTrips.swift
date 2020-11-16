//
//  MyTrips.swift
//  TJA
//
//  Created by Miron Rogovets on 11.11.2020.
//

import SwiftUI

struct MyTrips: View {
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationBarTitle(Text("My trips".uppercased()))
        }
    }
}

struct MyTrips_Previews: PreviewProvider {
    static var previews: some View {
        MyTrips()
    }
}
