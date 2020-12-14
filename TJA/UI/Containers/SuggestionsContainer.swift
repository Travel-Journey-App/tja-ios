//
//  SuggestionsContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct SuggestionsContainer: View {
    
    var items: [SuggestionPlace] = []
    let wish: WishItem
    
    @State var selectedIndex: Int? = nil
    
    var body: some View {
        
        let isSelected = Binding<Bool>(
            get: { return selectedIndex != nil },
            set: { if !$0 { self.selectedIndex = nil} }
        )
        
        return ZStack(alignment: .top) {
            if items.count > 0 {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(0..<items.count) { id in
                            SuggestionCell(suggestion: items[id])
                                .onTapGesture { self.selectedIndex = id }
                        }
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                }
            } else {
                Text("There are no items from the \(wish.rawValue.capitalizedFirstLetter()) category that we can recommend\n☹️")
                    .font(.system(size: 20))
                    .foregroundColor(.mainRed)
                    .multilineTextAlignment(.center)
            }
            if selectedIndex != nil {
                PopUpContainer(isShown: isSelected) {
                    SuggestionCard(
                        suggestion: items[selectedIndex ?? 0],
                        wishTitle: wish.rawValue,
                        onDismiss: {
                            self.selectedIndex = nil
                        },
                        onAdd: {
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
        SuggestionsContainer(items: [], wish: .lunch)
    }
}
