//
//  EventCard.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct EventCard: View {
    
    var event: Event
    var dayNumber: Int
    @Binding var notes: String
    
    
    var onDelete: (() -> ())?
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text("Day \(dayNumber)")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color("MainRed"))
                .padding(5)
            HStack(spacing: 20){
                // Icon
                event.eventType.eventIcon
                // Title + Time
                VStack(alignment: .leading, spacing: 0) {
                    Text(event.name)
                        .lineLimit(1)
                        .font(.system(size: 15, weight: .bold))
                    Text(event.timeString)
                        .lineLimit(1)
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(UIColor.systemGray))
                    Button(action: { self.onDelete?() }, label: {
                        Image(systemName: "trash")
                            .frame(width: 24, height: 24, alignment: .center)
                    }).accentColor(Color(UIColor.systemGray))
                }
            }
            Text("Modern cafe with brilliant burgers and music\nDon't forget to visit our brand shop!")
                .font(.system(size: 12))
                .foregroundColor(Color(UIColor.brown))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            TextField("Notes...", text: $notes)
                .textFieldStyle(BorderedTextField(color: Color("LightRedBorder"), borderSize: 1))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .frame(height: 24)
                .padding(.vertical, 8)
        }
        .padding(.bottom, 13)
        .padding(.horizontal, 10)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .strokeBorder(Color(UIColor.opaqueSeparator), lineWidth: 1))
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        let events = Mockup.Events.generateEvents()
        EventCard(event: events[1], dayNumber: 1, notes: .constant(""))
    }
}
