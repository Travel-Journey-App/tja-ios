//
//  SuggestionCard.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct SuggestionCard: View {
    
    let suggestion: SuggestionPlace
    let wishTitle: String
    
    var onDismiss: (() -> ())?
    var onAdd: (() -> ())?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(wishTitle.uppercased())
                .font(.system(size: 35))
                .foregroundColor(.mainRed)
                .padding(5)
            KFImage(suggestion.photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 138)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(suggestion.name)
                    .font(.system(size: 20))
                    .bold()
                    .lineLimit(2)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(suggestion.extraName)
                        .lineLimit(1)
                        .font(.system(size: 14))
                    Text(suggestion.workingHours)
                        .lineLimit(1)
                        .font(.system(size: 14))
                }
                .foregroundColor(Color(UIColor.systemGray))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 2)
                
                ScrollView {
                    Text(suggestion.description)
                        .font(.system(size: 12, weight: .light))
                        .lineLimit(nil)
                        .padding(5)
                }
                .frame(maxWidth: .infinity, maxHeight: 128, alignment: .center)
                .border(Color(UIColor.systemFill), width: 1)
                
            }.padding(.top, 2)
            HStack(alignment: .center) {
                Button(action: { self.onDismiss?() }, label: { Text("Cancel") })
                    .frame(maxWidth: .infinity)
                Divider()
                Button(action: { self.onAdd?() }, label: { Text("Add") })
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 36)
        }
        .padding(.top, 17)
        .padding(.bottom, 2)
        .padding(.horizontal, 25)
        .border(Color(UIColor.opaqueSeparator), width: 1)
        .background(Color(UIColor.systemBackground))
    }
}

struct SuggestionCard_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionCard(suggestion:
                        .init(id: "0", category: .bar, description: "Greek pastries and desserts, freshly made! Also serving iced coffee variations like freddo espresso. A cosy and friendly environment that makes you feel home!", workingHours: "Open: Sat 12:00 - 13:00", price: .cheap, location: .init(lat: 74, lon: 75), name: "Some name", photo: URL(string: "https://images.unsplash.com/photo-1605546741978-365c16813d0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1575&q=80"), rating: 4.7, extraName: "Extra name"),
                       wishTitle: WishItem.breakfast.rawValue
        )
    }
}
