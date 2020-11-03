//
//  Home.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        if let user = authState.currentUser {
            Text("Welcome home, \(user.name)")
        } else {
            Text("No user")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(AuthState.shared)
    }
}
