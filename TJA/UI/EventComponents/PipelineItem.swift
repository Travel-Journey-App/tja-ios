//
//  PipelineItem.swift
//  TJA
//
//  Created by Miron Rogovets on 02.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct PipelineItem: View {
    
    var activity: Activity
    
    var body: some View {
        if activity.scheduled {
            HStack(spacing: 5) {
                CircleIcon(icon: activity.activityType.eventIcon)
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
                activity.activityType.eventIcon
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
            Text(activity.name)
                .lineLimit(1)
                .font(.system(size: 15, weight: .bold))
                .padding(.horizontal, 9)
            Text(activity.timeString)
                .lineLimit(1)
                .font(.system(size: 13))
                .padding(.horizontal, 9)
        }
    }
}

struct PipelineItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .center, spacing: 12) {
            PipelineItem(activity: Activity(id: 0, name: "Name", description: nil, startTime: nil, endTime: nil, note: "", location: nil, activityType: .event(.bar)))
        }.background(Color.blue.opacity(0.5))
    }
}
