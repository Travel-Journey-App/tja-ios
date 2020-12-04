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
    @State var events: [Event]
    @State var swipeableItems: [SwipeableItem<Event>]
    var active: Bool
//    var onRemove: ((Int) -> ())?
    
    init(_ events: [Event], dayNumber: Int = 1, active: Bool = true) {
        self.dayNumber = dayNumber
        self._disablePipeline = .init(initialValue: events.allSatisfy({ !$0.scheduled }))
        self._events = .init(initialValue: events)
        self._swipeableItems = .init(initialValue: events.compactMap {
            SwipeableItem<Event>(item: $0, offset: 0, isSwiped: false)
        })
        self.active = active
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day \(dayNumber + 1)")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .foregroundColor(Color("MainRed"))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            ZStack(alignment: .topLeading) {
                if !disablePipeline {
                    Rectangle()
                        .fill(Color("MainRed"))
                        .padding(.vertical, 10)
                        .frame(width: 2, height: pipelineHeight, alignment: .leading)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(events) { event in
                        Swipeable(
                            $swipeableItems[getIndex(id: event.id)],
                            onSwiped: {
//                                let id = swipeableItems[index].id
                                print("DEBUG: -- onSwiped tirggered for -- \(event.id)")
                                self.delete(by: event.id)
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
        .overlay(active ? Color.clear : Color.white.opacity(0.7))
    }
    
    var pipelineHeight: CGFloat {
        // events.count * 40 + 12 * (events.count - 1)
        CGFloat(swipeableItems.count > 1 ? 52 * swipeableItems.count - 12 : 0)
    }
    
    private func loadSwipeable(with events: [Event]) {
        self.swipeableItems = events.compactMap {
            SwipeableItem<Event>(item: $0, offset: 0, isSwiped: false)
        }
    }
    
    private func delete(by id: Int) {
        print("DEBUG: -- Before removal Swipeable: \(swipeableItems.count)")
        self.events.removeAll(where: { $0.id == id })
        self.loadSwipeable(with: self.events)
        print("DEBUG: -- After removal Swipeable: \(swipeableItems.count)")
    }
    
    private func getIndex(id: Int) -> Int {
        print("DEBUG: -- Getting index = \(id)")
        return swipeableItems.firstIndex { (item) -> Bool in
            return id == item.id
        } ?? 0
    }
}

struct DayCell_Previews: PreviewProvider {
    static var previews: some View {
        let events = Mockup.Events.generateEvents(dayNumber: 2)
        DayCell(events, dayNumber: 1)
    }
}
