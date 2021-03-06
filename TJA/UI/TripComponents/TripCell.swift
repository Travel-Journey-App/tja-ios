//
//  TripCell.swift
//  TJA
//
//  Created by Miron Rogovets on 16.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct TripCell: View {
    
    var trip: Trip
    @State var isEditing = false
    @State var name = ""
    
    var onNameChanged: ((String) -> ())?
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        HStack(spacing: 6) {
            KFImage(trip.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 84)
                .border(Color.mainRed, width: 2)
                .clipped()
            
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    if isEditing {
                        FocusableTextField(
                            text: $name,
                            placeholder: "Trip name",
                            isFirstResponder: true,
                            onEditingChanged: { val in
                                print("DEBUG: -- onEditingChanged")
                                if !val { self.isEditing = false }
                            },
                            onCommit: {
                                print("DEBUG: -- onCommit")
                                if !name.isEmpty && name != trip.name {
                                    self.onNameChanged?(name)
                                }
                                self.isEditing = false
                            })
                            .frame(height: 21.5)
                    } else {
                        Text(trip.name)
                            .font(.system(size: 18))
                            .bold()
                            .onLongPressGesture {
                                self.isEditing = true
                                self.name = trip.name
                                self.generator.impactOccurred()
                            }
                    }
                   
                    Text(trip.interval).font(.system(size: 13))
                    if !trip.isFinished {
                        HStack(spacing: 5) {
                            Image(systemName: "clock")
                                .frame(width: 24, height: 24)
                                .foregroundColor(.accentColor)
                            Text(trip.daysInOrAgo).font(.system(size: 15))
                        }
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
            .border(Color.mainRed, width: 2)
            
        }.background(Color(UIColor.systemBackground))
    }
}

struct TripCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TripCell(
                trip: Trip(
                    id: 0,
                    image: URL(string: "https://images.unsplash.com/photo-1605546741978-365c16813d0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1575&q=80"),
                    name: "New Year",
                    startDate: Date().addingTimeInterval(60*60*24*2),
                    endDate: Date().addingTimeInterval(60*60*24*6),
                    location: nil, days: [])
            )
            TripCell(
                trip: Trip(
                    id: 0,
                    image: URL(string: "https://images.unsplash.com/photo-1605546741978-365c16813d0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1575&q=80"),
                    name: "New Year",
                    startDate: Date().addingTimeInterval(-60*60*24*9),
                    endDate: Date().addingTimeInterval(-60*60*24*6),
                    location: nil, days: [])
            )
        }
        
    }
}
