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
        case .system:
            return Image(systemName: name).resizable().toAnyView()
        case .custom:
            return Image(name)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .toAnyView()
        }
    }
    
    var uiimage: UIImage? {
        switch source {
        case .system: return UIImage(systemName: name)
        case .custom: return UIImage(named: name)
        }
    }
}

struct EventIcon_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                Activity.ActivityType.event(.bar).eventIcon
                Activity.ActivityType.event(.food).eventIcon
                Activity.ActivityType.event(.museum).eventIcon
                Activity.ActivityType.event(.fun).eventIcon
                Activity.ActivityType.event(.sightseeing).eventIcon
                Activity.ActivityType.event(.gallery).eventIcon
                Activity.ActivityType.accommodation(.checkin).eventIcon
            }
            EventIcon(name: "calendar")
            VStack {
                Activity.ActivityType.transfer(.plane, .arrival).eventIcon
                Activity.ActivityType.transfer(.plane, .departure).eventIcon
                Activity.ActivityType.transfer(.bus, .arrival).eventIcon
                Activity.ActivityType.transfer(.car, .arrival).eventIcon
                Activity.ActivityType.transfer(.ship, .arrival).eventIcon
                Activity.ActivityType.transfer(.train, .arrival).eventIcon
                Activity.ActivityType.transfer(.plane, .arrival).categoryIcon
            }
        }
        
    }
}
