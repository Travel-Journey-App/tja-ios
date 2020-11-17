//
//  TripCell.swift
//  TJA
//
//  Created by Miron Rogovets on 16.11.2020.
//

import SwiftUI
import KingfisherSwiftUI

struct TripCell: View {
    
    var trip: Trip
    
    var body: some View {
        HStack(spacing: 6) {
            KFImage(trip.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 84)
                .border(Color("MainRed"), width: 2)
                .clipped()
            
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(trip.name)
                        .font(.system(size: 18))
                        .bold()
                    Text(trip.interval).font(.system(size: 13))
                    HStack(spacing: 5) {
                        Image(systemName: "clock")
                            .frame(width: 24, height: 24)
                            .foregroundColor(.accentColor)
                        Text(trip.daysInOrAgo).font(.system(size: 15))
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .frame(width: 24, height: 24)
                    .foregroundColor(.accentColor)
            }
            .padding(.trailing, 12)
            .padding(.leading, 7)
            .frame(height: 84)
            .frame(maxWidth: .infinity)
            .border(Color("MainRed"), width: 2)
            
        }
    }
}

struct TripCell_Previews: PreviewProvider {
    static var previews: some View {
        TripCell(
            trip: Trip(
                id: 0,
                image: URL(string: "https://images.unsplash.com/photo-1605546741978-365c16813d0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1575&q=80"),
                name: "New Year",
                startDate: Date().addingTimeInterval(60*60*24*2),
                endDate: Date().addingTimeInterval(60*60*24*6))
        )
    }
}
