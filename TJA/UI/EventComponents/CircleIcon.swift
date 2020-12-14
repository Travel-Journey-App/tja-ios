//
//  CircleIcon.swift
//  TJA
//
//  Created by Miron Rogovets on 02.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct CircleIcon: View {
    
    var icon: EventIcon
    var size: CGFloat = 35
    
    var body: some View {
        Circle()
            .strokeBorder(Color.mainRed, lineWidth: 2)
            .background(
                Circle()
                    .fill(Color(UIColor.systemBackground))
                    .overlay(icon, alignment: .center)
            ).frame(width: size, height: size, alignment: .center)
    }
}

struct CircleIcon_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                CircleIcon(icon: Activity.ActivityType.event(.bar).eventIcon)
                CircleIcon(icon: Activity.ActivityType.event(.food).eventIcon)
                CircleIcon(icon: Activity.ActivityType.event(.museum).eventIcon)
                CircleIcon(icon: Activity.ActivityType.event(.fun).eventIcon)
                CircleIcon(icon: Activity.ActivityType.event(.sightseeing).eventIcon)
                CircleIcon(icon: Activity.ActivityType.event(.gallery).eventIcon)
                CircleIcon(icon: Activity.ActivityType.accommodation(.checkin).eventIcon)
            }
            VStack {
                CircleIcon(icon: Activity.ActivityType.transfer(.plane, .arrival).eventIcon)
                CircleIcon(icon: Activity.ActivityType.transfer(.plane, .departure).eventIcon)
                CircleIcon(icon: Activity.ActivityType.transfer(.bus, .arrival).eventIcon)
                CircleIcon(icon: Activity.ActivityType.transfer(.car, .arrival).eventIcon)
                CircleIcon(icon: Activity.ActivityType.transfer(.ship, .arrival).eventIcon)
                CircleIcon(icon: Activity.ActivityType.transfer(.train, .arrival).eventIcon)
                CircleIcon(icon: Activity.ActivityType.transfer(.plane, .arrival).categoryIcon)
            }
        }
    }
}
