//
//  WishItemsContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct WishItemsContainer: View {
    
    let wish: WishItem
    var items: [SuggestionPlace] = []
    var location: Location?
    
    var body: some View {
        SegmentedContainer(
            list: { SuggestionsContainer(items: items, wish: wish) },
            map: { MapContainer(location: location) }
        )
        .navigationBarTitle(Text("I wish...".uppercased()), displayMode: .inline)
    }
}

struct WishItemsContainer_Previews: PreviewProvider {
    static var previews: some View {
        WishItemsContainer(wish: .bar, items: [])
    }
}
