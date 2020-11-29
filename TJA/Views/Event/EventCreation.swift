//
//  EventCreation.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct EventCreation: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                NavigationLink(destination: NewTransfer()) {
                    BorderTitleImage(source: .transfer)
                }
                .buttonStyle(PlainButtonStyle())
                NavigationLink(destination: NewAccommodation()) {
                    BorderTitleImage(source: .accomodation)
                }
                .buttonStyle(PlainButtonStyle())
                NavigationLink(destination: NewActivity()) {
                    BorderTitleImage(source: .event)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 10)
            .navigationBarTitle(Text("Add new item".uppercased()), displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action: { self.presentationMode.wrappedValue.dismiss() },
                    label: { Text("Cancel") }
                )
            )
        }
    }
}

struct EventCreation_Previews: PreviewProvider {
    static var previews: some View {
        EventCreation()
    }
}
