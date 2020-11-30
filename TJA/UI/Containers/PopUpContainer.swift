//
//  PopUpContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct PopUpContainer<Content: View>: View {
    
    @Binding var isBlurShown: Bool
    
    private let content: () -> Content
    
    init(isShown: Binding<Bool>, @ViewBuilder content:@escaping () -> Content) {
        self._isBlurShown = isShown
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            BlurView().onTapGesture {
                self.isBlurShown = false
            }
            self.content()
        }
    }
}

struct PopUpHolder_Previews: PreviewProvider {
    static var previews: some View {
        PopUpContainer(isShown: .constant(true)) {
//            Text("A")
            SuggestionCard(
                suggestion:
                                .init(id: 2, name: "Place with long desc", description: "Greek pastries and desserts, freshly made! Also serving iced coffee variations like freddo espresso. A cosy and friendly environment that makes you feel home! Offers a gluten free menu.Greek pastries and desserts, freshly made! Also serving iced coffee variations like freddo espresso. A cosy and friendly environment that makes you feel home! Offers a gluten free menu.", rating: 4.222, price: .medium, location: Mockup.Locations.eventLocations["Museum of modern art"]!, openHours: nil, imageUrl: URL(string: "https://images.unsplash.com/photo-1605546741978-365c16813d0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1575&q=80")!),
                               wishTitle: WishItem.breakfast.rawValue
            )
            .padding(.horizontal, 30)
        }.background(Color.red)
    }
}
