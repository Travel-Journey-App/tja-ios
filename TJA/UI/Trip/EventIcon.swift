//
//  EventIcon.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct EventIcon: View {
    
    enum Source {
        case system, custom
    }
    
    var name: String
    var source: Source = .system
    
    var body: some View {
        image
            .foregroundColor(Color(UIColor.label))
            .frame(width: 24, height: 24, alignment: .center)
    }
    
    var image: some View {
        switch source {
        case .system: return Image(systemName: name).toAnyView()
        case .custom: return Image(name)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .toAnyView()
        }
    }
}

struct EventIcon_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                EventType.activity(activity: .bar).eventIcon
                EventType.activity(activity: .food).eventIcon
                EventType.activity(activity: .museum).eventIcon
                EventType.activity(activity: .fun).eventIcon
                EventType.activity(activity: .sightseeing).eventIcon
                EventType.activity(activity: .gallery).eventIcon
                
            }
            VStack {
                EventType.accomodation.eventIcon
                EventType.transfer(transfer: .plane, arrival: true).eventIcon
                EventType.transfer(transfer: .plane, arrival: false).eventIcon
                EventType.transfer(transfer: .bus, arrival: true).eventIcon
                EventType.transfer(transfer: .car, arrival: true).eventIcon
                EventType.transfer(transfer: .ship, arrival: true).eventIcon
                EventType.transfer(transfer: .train, arrival: true).eventIcon
                EventType.transfer(transfer: .plane, arrival: true).categoryIcon
            }
        }
        
    }
}
