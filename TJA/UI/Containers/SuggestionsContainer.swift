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
    
    var body: some View {
        ZStack(alignment: .top) {
            if items.count > 0 {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(items) { item in
                            SuggestionCell(suggestion: item)
                        }
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                }
            } else {
                Text("There are no items from the \(wish.rawValue.capitalizedFirstLetter()) category that we can recommend\n☹️")
                    .font(.system(size: 20))
                    .foregroundColor(Color("MainRed"))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct SuggestionsContainer_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsContainer(items: Mockup.Wishes.suggestions, wish: .lunch)
    }
}
