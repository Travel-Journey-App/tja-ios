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
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Welcome home\(welcomeText)")
                .onTapGesture {
                    authState.logout()
                }
                .tabItem {
                    Image(systemName: "map")
                    Text("My trips")
                }
            Text("Account")
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
        }
    }
    
    private var welcomeText: String {
        if let user = authState.currentUser {
            return ", \(user.name)"
        } else {
            return ""
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(AuthState.shared)
    }
}
