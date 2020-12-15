//
//  MagicMode.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct MagicMode: View {
    
    @Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var viewModel: ActivityViewModel
    
    var body: some View {
        NavigationView {
            Text("Magic Mode")
                .navigationBarTitle(Text("Magic mode".uppercased()), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(
                        action: { self.presentationMode.wrappedValue.dismiss() },
                        label: { Text("Cancel") }
                    ),
                    trailing: Button(
                        action: {
							self.viewModel.getMagicTrip(trip: viewModel.trip)
							self.presentationMode.wrappedValue.dismiss()
						},
                        label: { Text("Save") }
                    )
                )
        }
    }
}

struct MagicMode_Previews: PreviewProvider {
    static var previews: some View {
        MagicMode()
    }
}
