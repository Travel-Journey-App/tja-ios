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
                list: { SuggestionsContainer().environmentObject(viewModel) },
                map: { MapContainer(location: viewModel.location) }
            ).frame(maxHeight: .infinity, alignment: .top)
            
            if popupViewModel.hasValue {
                PopUpContainer(isShown: isShown) {
                    SuggestionCard(
                        suggestion: viewModel.items[popupViewModel.selectedIndex ?? 0],
                        wishTitle: viewModel.wish.rawValue,
                        onDismiss: { self.popupViewModel.reset() },
                        onAdd: {
                            if let index = popupViewModel.selectedIndex {
                                self.onAdd?(viewModel.items[index])
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
