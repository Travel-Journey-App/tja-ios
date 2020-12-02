//
//  PipelineItem.swift
//  TJA
//
//  Created by Miron Rogovets on 02.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct PipelineItem: View {
    
    var event: Event
    
    var body: some View {
        if event.scheduled {
            HStack(spacing: 5) {
                CircleIcon(icon: event.eventType.eventIcon)
                detailStack
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .strokeBorder(Color(UIColor.opaqueSeparator), lineWidth: 1))
                
            }
        } else {
            HStack(spacing: 5) {
                event.eventType.eventIcon
                    .padding(.horizontal, 5)
                detailStack
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
            }
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .strokeBorder(Color(UIColor.opaqueSeparator), lineWidth: 1))
        }
    }
    
    var detailStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(event.name)
                .lineLimit(1)
                .font(.system(size: 15, weight: .bold))
                .padding(.horizontal, 9)
            Text(event.timeString)
                .lineLimit(1)
                .font(.system(size: 13))
                .padding(.horizontal, 9)
        }
    }
}

struct PipelineItem_Previews: PreviewProvider {
    static var previews: some View {
        let events = Mockup.Events.generateEvents()
        VStack(alignment: .center, spacing: 12) {
            PipelineItem(event: events[0])
            PipelineItem(event: events[1])
            PipelineItem(event: events[2])
        }.background(Color.blue.opacity(0.5))
    }
}
