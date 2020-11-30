//
//  WishList.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct WishList: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private let items: [WishItem] = [
        .breakfast, .lunch, .dinner, .bar,
        .gallery, .sightseeng, .museums, .fun
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                Grid(columns: 2, list: items, vSpacing: 25) { wish in
                    ShadowImage(name: wish.image)
                        .frame(width: 128, height: 128, alignment: .center)
                }
                .padding(25)
            }
            .navigationBarTitle(Text("I wish...".uppercased()), displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action: { self.presentationMode.wrappedValue.dismiss() },
                    label: { Text("Cancel") }
                )
            )
        }
    }
}

struct WishList_Previews: PreviewProvider {
    static var previews: some View {
        WishList()
    }
}
