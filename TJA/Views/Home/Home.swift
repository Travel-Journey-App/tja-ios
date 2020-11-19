//
//  Home.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var authState: AuthState
    
    @State var selectedTab = Tab.trips
    
    enum Tab: Int {
        case trips, account
    }
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyTrips().tabItem {
                self.tabbarItem(text: "My trips", image: "map")
            }.tag(Tab.trips)
            Account().tabItem {
                self.tabbarItem(text: "Account", image: "person.crop.circle")
            }.tag(Tab.account)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(AuthState.shared)
    }
}
