//
//  DayCell.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct DayCell: View {
    
    var dayNumber: Int
    @State var swipeableItems: [SwipeableItem<Event>]
    
    init(_ events: [Event], dayNumber: Int = 1) {
        self.dayNumber = dayNumber
        self._swipeableItems = .init(initialValue: events.compactMap {
            SwipeableItem<Event>(item: $0, offset: 0, isSwiped: false)
        })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day \(dayNumber)")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .foregroundColor(Color("MainRed"))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color("MainRed"))
                    .padding(.vertical, 10)
                    .frame(width: 2, height: pipelineHeight, alignment: .leading)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<swipeableItems.count) { index in
                        Swipeable(
                            $swipeableItems[index],
                            onSwiped: {
                                print("DEBUG: -- onSwiped tirggered for -- \(index)")
                            },
                            style: .rounded(7),
                            insets: .leading(40)
                        ) { event in
                            PipelineItem(event: event)
                        }
                        .frame(height: 40)
                    }
                }
            }
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("TripCellBackground")))
    }
    
    var pipelineHeight: CGFloat {
        // events.count * 40 + 12 * (events.count - 1)
        CGFloat(swipeableItems.count > 1 ? 52 * swipeableItems.count - 12 : 0)
    }
}

struct DayCell_Previews: PreviewProvider {
    static var previews: some View {
        let events = Mockup.Events.generateEvents(dayNumber: 2)
        DayCell(events, dayNumber: 1)
    }
}
