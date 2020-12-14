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
        .border(Color.mainRed, width: 1)
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
                suggestion: .init(id: "0", category: .bar, description: "Greek pastries and desserts, freshly made! Also serving iced coffee variations like freddo espresso. A cosy and friendly environment that makes you feel home!", workingHours: .init(open: 10800, close: 72000), price: .cheap, location: .init(lat: 74, lon: 75), name: "Some name", photo: URL(string: "https://images.unsplash.com/photo-1605546741978-365c16813d0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1575&q=80"), rating: 4.7, extraName: "Extra name")
            )
        }
    }
}
