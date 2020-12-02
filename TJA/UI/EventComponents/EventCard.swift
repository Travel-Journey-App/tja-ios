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
                    Text("Closed")
                        .lineLimit(1)
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Button(action: {}, label: {
                        Image(systemName: "clock")
                            .frame(width: 24, height: 24, alignment: .center)
                    })
                    Button(action: {}, label: {
                        Image(systemName: "trash")
                            .frame(width: 24, height: 24, alignment: .center)
                    })
                }
            }
            Text("Event description goes here")
                .font(.system(size: 12))
                .foregroundColor(Color(UIColor.brown))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            TextField("Notes...", text: $notes)
                .textFieldStyle(BorderedTextField())
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .frame(height: 24)
                .padding(.vertical, 5)
        }
        .padding(.bottom, 13)
        .padding(.horizontal, 10)
        .border(Color(UIColor.opaqueSeparator), width: 1)
        .background(Color(UIColor.systemBackground))
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        let events = Mockup.Events.generateEvents()
        EventCard(event: events[1], dayNumber: 1, notes: .constant(""))
    }
}
