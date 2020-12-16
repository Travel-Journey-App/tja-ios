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
    @EnvironmentObject var popupViewModel: PopupSuggestionViewModel
    
    var onAdd: ((SuggestionPlace) -> ())?
    
    var body: some View {
        let isShown = Binding<Bool>(
            get: { return popupViewModel.hasValue },
            set: { if !$0 { popupViewModel.reset() } }
        )
        return ZStack {
            SegmentedContainer(
                list: { SuggestionsContainer() },
                map: { SuggestionMapContainer(location: viewModel.location) }
            ).frame(maxHeight: .infinity, alignment: .top)
            
            if popupViewModel.hasValue {
                PopUpContainer(isShown: isShown) {
                    SuggestionCard(
                        suggestion: popupViewModel.selected ?? viewModel.items[0],
                        wishTitle: viewModel.wish.rawValue,
                        onDismiss: { self.popupViewModel.reset() },
                        onAdd: {
                            if let place = popupViewModel.selected {
                                self.onAdd?(place)
                            }
                            self.popupViewModel.reset()
                        })
                        .padding(.horizontal, 30)
                }
            }
        }
        .navigationBarTitle(Text("I wish...".uppercased()), displayMode: .inline)
        .onAppear {
            self.viewModel.fetchItems()
            self.popupViewModel.reset()
        }
    }
}

struct WishItemsContainer_Previews: PreviewProvider {
    static var previews: some View {
        WishItemsContainer()
    }
}
