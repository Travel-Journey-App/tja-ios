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
    @State var disablePipeline: Bool
    @Binding var swipeableItems: [SwipeableItem<Activity>]
    var active: Bool
    var onRemove: ((Activity) -> ())?
    
    init(
        _ events: Binding<[SwipeableItem<Activity>]>,
        dayNumber: Int = 1,
        active: Bool = true,
        onRemove: ((Activity) -> ())? = nil) {
        
        self.dayNumber = dayNumber
        self._disablePipeline = .init(initialValue: events.wrappedValue.allSatisfy({ !$0.item.scheduled }))
        self._swipeableItems = events
        self.active = active
        self.onRemove = onRemove
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day \(dayNumber)")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .foregroundColor(.mainRed)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            ZStack(alignment: .topLeading) {
                if !disablePipeline {
                    Rectangle()
                        .fill(Color.mainRed)
                        .padding(.vertical, 10)
                        .frame(width: 2, height: pipelineHeight, alignment: .leading)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<swipeableItems.count, id: \.self) { i in
                        Swipeable(
                            $swipeableItems[i],
                            onSwiped: {
//                                let id = swipeableItems[index].id
                                print("DEBUG: -- onSwiped tirggered for -- \(swipeableItems[i])")
                                self.onRemove?(swipeableItems[i].item)
                            },
                            style: .rounded(7),
                            insets: .leading(40)
                        ) { event in
                            PipelineItem(activity: event)
                        }
                        .frame(height: 40)
                    }
                }
            }
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.tripBackground))
        .overlay(active ? Color.clear : Color.white.opacity(0.7))
    }
    
    var pipelineHeight: CGFloat {
        // events.count * 40 + 12 * (events.count - 1)
        CGFloat(swipeableItems.count > 1 ? 52 * swipeableItems.count - 12 : 0)
    }
}

struct DayCell_Previews: PreviewProvider {
    static var previews: some View {
        DayCell(.constant([]), dayNumber: 1)
    }
}
