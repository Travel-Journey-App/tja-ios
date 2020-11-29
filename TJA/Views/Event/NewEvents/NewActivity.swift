//
//  NewActivity.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct NewActivity: View {
    var body: some View {
        Text("New event")
            .navigationBarTitle(Text("Add Event".uppercased()), displayMode: .inline)
    }
}

struct NewActivity_Previews: PreviewProvider {
    static var previews: some View {
        NewActivity()
    }
}
