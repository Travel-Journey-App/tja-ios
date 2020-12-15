//
//  EventCard.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct EventCard: View {
    
    var activity: Activity
    var dayNumber: Int
    var onDelete: ((Activity) -> ())?
    var onCommit: ((String) -> ())?
    
    @State var notes: String
    
    init(
        _ activity: Activity,
        dayNumber: Int,
        onDelete: ((Activity) -> ())? = nil,
        onCommit: ((String) -> ())? = nil) {
//        self._activity = .init(initialValue: activity)
        self.activity = activity
        self._notes = .init(initialValue: activity.note)
        self.dayNumber = dayNumber
        self.onDelete = onDelete
        self.onCommit = onCommit
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text("Day \(dayNumber)")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.mainRed)
                .padding(5)
            HStack(spacing: 20){
                // Icon
                activity.activityType.eventIcon
                // Title + Time
                VStack(alignment: .leading, spacing: 0) {
                    Text(activity.name)
                        .lineLimit(1)
                        .font(.system(size: 15, weight: .bold))
                    Text(activity.timeString)
                        .lineLimit(1)
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(UIColor.systemGray))
                    Button(action: { self.onDelete?(self.activity) }, label: {
                        Image(systemName: "trash")
                            .frame(width: 24, height: 24, alignment: .center)
                    }).accentColor(Color(UIColor.systemGray))
                }
            }
            Text(activity.description ?? "")
                .font(.system(size: 12))
                .foregroundColor(Color(UIColor.brown))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            TextField("Notes...", text: $notes, onCommit:  {
                self.onCommit?(self.notes)
            })
                .textFieldStyle(BorderedTextField(color: .lightRedBorder, borderSize: 1))
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
                .strokeBorder(Color(UIColor.opaqueSeparator), lineWidth: 2))
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCard(Activity(id: 0, name: "Name", description: "Some description", startTime: nil, endTime: nil, note: "", location: nil, activityType: .event(.bar)), dayNumber: 1)
    }
}
