//
//  SignUp.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct SignUp: View {
    
    @Binding var showingSignUp: Bool
    
    var body: some View {
        Text("SignUp")
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(showingSignUp: .constant(true))
    }
}
