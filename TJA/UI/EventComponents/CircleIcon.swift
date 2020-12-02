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
            .strokeBorder(Color("MainRed"), lineWidth: 2)
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
                CircleIcon(icon: EventType.activity(activity: .bar).eventIcon)
                CircleIcon(icon: EventType.activity(activity: .food).eventIcon)
                CircleIcon(icon: EventType.activity(activity: .museum).eventIcon)
                CircleIcon(icon: EventType.activity(activity: .fun).eventIcon)
                CircleIcon(icon: EventType.activity(activity: .sightseeing).eventIcon)
                CircleIcon(icon: EventType.activity(activity: .gallery).eventIcon)
                CircleIcon(icon: EventType.accomodation.eventIcon)
            }
            VStack {
                CircleIcon(icon: EventType.transfer(transfer: .plane, direction: .arrival).eventIcon)
                CircleIcon(icon: EventType.transfer(transfer: .plane, direction: .departure).eventIcon)
                CircleIcon(icon: EventType.transfer(transfer: .bus, direction: .arrival).eventIcon)
                CircleIcon(icon: EventType.transfer(transfer: .car, direction: .arrival).eventIcon)
                CircleIcon(icon: EventType.transfer(transfer: .ship, direction: .arrival).eventIcon)
                CircleIcon(icon: EventType.transfer(transfer: .train, direction: .arrival).eventIcon)
                CircleIcon(icon: EventType.transfer(transfer: .plane, direction: .arrival).categoryIcon)
            }
        }
    }
}
