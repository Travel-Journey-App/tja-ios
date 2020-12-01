//
//  SuggestionsContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct WishItemsContainer: View {
    
    var location: Location?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarTitle(Text("I wish...".uppercased()), displayMode: .inline)
    }
}

struct SuggestionsContainer_Previews: PreviewProvider {
    static var previews: some View {
        WishItemsContainer()
    }
}
