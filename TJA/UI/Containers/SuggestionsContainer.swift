//
//  SuggestionsContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct SuggestionsContainer: View {
    
    @EnvironmentObject var viewModel: WishViewModel
    
    @State var selectedIndex: Int? = nil
    
    var onAdd: ((SuggestionPlace) -> ())?
    
    var body: some View {
        
        let isSelected = Binding<Bool>(
            get: { return selectedIndex != nil },
            set: { if !$0 { self.selectedIndex = nil} }
        )
        
        return ZStack(alignment: .top) {
            if viewModel.items.count > 0 {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(0..<viewModel.items.count, id: \.self) { i in
                            SuggestionCell(suggestion: viewModel.items[i])
                                .onTapGesture { self.selectedIndex = i }
                        }
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                }
            } else {
                Text("There are no items from the \(viewModel.wish.rawValue.capitalizedFirstLetter()) category that we can recommend\n☹️")
                    .font(.system(size: 20))
                    .foregroundColor(.mainRed)
                    .multilineTextAlignment(.center)
            }
            if selectedIndex != nil {
                PopUpContainer(isShown: isSelected) {
                    SuggestionCard(
                        suggestion: viewModel.items[selectedIndex ?? 0],
                        wishTitle: viewModel.wish.rawValue,
                        onDismiss: {
                            self.selectedIndex = nil
                        },
                        onAdd: {
                            if let index = selectedIndex {
                                self.onAdd?(viewModel.items[index])
                            }
                            self.selectedIndex = nil
                        })
                        .padding(.horizontal, 30)
                }
            }
        }
    }
}

struct SuggestionsContainer_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsContainer()
    }
}
