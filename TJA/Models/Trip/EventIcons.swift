//
//  EventIcons.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import SwiftUI


extension EventType.Activity {
    
    var icon: EventIcon {
        switch self {
        case .food: return EventIcon(name: "lunch", source: .custom)
        case .bar: return EventIcon(name: "bar", source: .custom)
        case .gallery: return EventIcon(name: "art", source: .custom)
        case .museum: return EventIcon(name: "museum", source: .custom)
        case .sightseeing: return EventIcon(name: "terrain", source: .custom)
        case .fun: return EventIcon(name: "fun", source: .custom)
        }
    }
}

extension EventType.Transfer {
    
    var icon: EventIcon {
        switch self {
        case .plane: return EventIcon(name: "airplane")
        case .train: return EventIcon(name: "tram.fill")
        case .ship: return EventIcon(name: "boat", source: .custom)
        case .bus: return EventIcon(name: "bus", source: .custom)
        case .car: return EventIcon(name: "car.fill")
        }
    }
}

extension EventType {
    
    var categoryIcon: EventIcon {
        switch self {
        case .accomodation: return EventIcon(name: "bed.double.fill")
        case .activity(let activity): return activity.icon
        case .transfer(let transfer, _): return transfer.icon
        }
    }
    
    var eventIcon: EventIcon {
        switch self {
        case .transfer(let transfer, let arrival):
            switch transfer {
            case .plane: return arrival ?
                EventIcon(name: "landing", source: .custom)
                : EventIcon(name: "takeoff", source: .custom)
            default: return transfer.icon
            }
        default: return categoryIcon
        }
    }
}
