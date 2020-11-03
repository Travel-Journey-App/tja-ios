//
//  Root.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct Root: View {
    
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        Group {
            if let _ = authState.currentUser {
                Home()
            } else {
                SignIn()
            }
        }.onAppear(perform: authState.restoreSession)
    }
}

struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root().environmentObject(AuthState.shared)
    }
}
