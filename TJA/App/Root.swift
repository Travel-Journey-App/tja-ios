//
//  Root.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct Root: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        if let _ = userData.currenUser {
            Home()
        } else {
            SignIn()
        }
    }
}

struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root().environmentObject(UserData())
    }
}
