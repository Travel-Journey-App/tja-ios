//
//  SuggestionCell.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct SuggestionCell: View {
    
    let suggestion: SuggestionPlace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(suggestion.name)
                .font(.system(size: 18, weight: .medium))
            HStack {
                Text(suggestion.description)
                    .font(.system(size: 12, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .center, spacing: 8) {
                    Text(suggestion.ratingString)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(suggestion.ratingColor)
                    Text(suggestion.cost)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(UIColor.systemYellow))
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: 100)
        .border(Color("MainRed"), width: 1)
    }
}

extension SuggestionPlace {
    var ratingColor: Color {
        rating >= 3.5 ? Color(UIColor.systemGreen) : Color(UIColor.systemRed)
    }
}

struct SuggestionCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SuggestionCell(
                suggestion: .init(id: 0, name: "Cheap place", description: "Greek pastries and desserts, freshly made! Also serving iced coffee variations like freddo espresso. A cosy and friendly environment that makes you feel home!", rating: 4.764, price: .cheap, location: Mockup.Locations.eventLocations["Museum of modern art"]!, openHours: nil, imageUrl: nil))
            SuggestionCell(
                suggestion: .init(id: 1, name: "Expensive place", description: "Very short description", rating: 4.55, price: .expensive, location: Mockup.Locations.eventLocations["Museum of modern art"]!, openHours: nil, imageUrl: nil))
            SuggestionCell(
                suggestion: .init(id: 2, name: "Place with normal desc", description: "Greek pastries and desserts, freshly made! Also serving iced coffee variations like freddo espresso. A cosy and friendly environment that makes you feel home! Offers a gluten free menu.", rating: 3.222, price: nil, location: Mockup.Locations.eventLocations["Museum of modern art"]!, openHours: nil, imageUrl: nil))
            SuggestionCell(
                suggestion: .init(id: 2, name: "Place with long desc", description: "Greek pastries and desserts, freshly made! Also serving iced coffee variations like freddo espresso. A cosy and friendly environment that makes you feel home! Offers a gluten free menu.Greek pastries and desserts, freshly made! Also serving iced coffee variations like freddo espresso. A cosy and friendly environment that makes you feel home! Offers a gluten free menu.", rating: 4.222, price: .medium, location: Mockup.Locations.eventLocations["Museum of modern art"]!, openHours: nil, imageUrl: nil))
        }
    }
}
