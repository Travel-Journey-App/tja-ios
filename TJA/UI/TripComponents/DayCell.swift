//
//  DayCell.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct DayCell: View {
    
    var dayNumber: Int = 1
    var events: [Event] = []
    
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
                    ForEach(events) { event in
                        PipelineItem(event: event)
                    }
                }
            }
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("TripCellBackground")))
    }
    
    var pipelineHeight: CGFloat {
        // events.count * 40 + 12 * (events.count - 1)
        CGFloat(events.count > 1 ? 52 * events.count - 12 : 0)
    }
}

struct DayCell_Previews: PreviewProvider {
    static var previews: some View {
        let events = Mockup.Events.generateEvents(dayNumber: 2)
        DayCell(dayNumber: 1, events: events)
    }
}
