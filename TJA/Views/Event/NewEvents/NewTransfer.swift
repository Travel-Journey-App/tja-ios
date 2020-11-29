//
//  NewTransfer.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct NewTransfer: View {
    var body: some View {
        Text("New transfer")
            .navigationBarTitle(Text("Add Transfer".uppercased()), displayMode: .inline)
    }
}

struct NewTransfer_Previews: PreviewProvider {
    static var previews: some View {
        NewTransfer()
    }
}
