//
//  NewAccommodation.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct NewAccommodation: View {
    var body: some View {
        Text("New accommodation")
            .navigationBarTitle(Text("Add Accommodation".uppercased()), displayMode: .inline)
    }
}

struct NewAccommodation_Previews: PreviewProvider {
    static var previews: some View {
        NewAccommodation()
    }
}
