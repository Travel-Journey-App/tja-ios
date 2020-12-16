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
    @EnvironmentObject var popupViewModel: PopupSuggestionViewModel
    
    var body: some View {
        
        switch viewModel.items {
        case .idle:
            return Color.clear.onAppear(perform: self.viewModel.fetchItems).toAnyView()
        case .loading: return
            VStack { //for center alignment
                Spacer()
                ActivityIndicatorView()
                Spacer()
            }.toAnyView()
            
        case .failed: return emptyPlaceholder.toAnyView()
        case let .loaded(items):
            return ZStack(alignment: .top) {
                if items.count > 0 {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(0..<items.count, id: \.self) { i in
                                SuggestionCell(suggestion: items[i])
                                    .onTapGesture {
                                        self.popupViewModel.selected = items[i]
                                    }
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 10)
                    }
                } else {
                    emptyPlaceholder
                }
            }.toAnyView()
        }
    }
    
    var emptyPlaceholder: some View {
        Text("There are no items from the \(viewModel.wish.rawValue.capitalizedFirstLetter()) category that we can recommend\n☹️")
            .font(.system(size: 20))
            .foregroundColor(.mainRed)
            .multilineTextAlignment(.center)
    }
}

struct SuggestionsContainer_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsContainer()
    }
}
