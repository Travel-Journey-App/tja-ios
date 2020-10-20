//
//  Home.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        if let user = userData.currenUser {
            Text("Welcome home, \(user.name)")
        } else {
            Text("No user")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(UserData())
    }
}
