//
//  WishItemsContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct WishItemsContainer: View {
    
    
    @EnvironmentObject var viewModel: WishViewModel
    
    var onAdd: ((SuggestionPlace) -> ())?
    
    var body: some View {
        SegmentedContainer(
            list: { SuggestionsContainer(onAdd: onAdd).environmentObject(viewModel) },
            map: { MapContainer(location: viewModel.location) }
        ).frame(maxHeight: .infinity, alignment: .top)
        .navigationBarTitle(Text("I wish...".uppercased()), displayMode: .inline)
        .onAppear {
            self.viewModel.fetchItems()
        }
    }
}

struct WishItemsContainer_Previews: PreviewProvider {
    static var previews: some View {
        WishItemsContainer()
    }
}
