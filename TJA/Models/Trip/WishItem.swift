//
//  WishItem.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

enum WishItem: String, Identifiable {
    case breakfast
    case lunch
    case dinner
    case bar
    case gallery
    case sightseeng
    case museums
    case fun
    
    var image: String {
        switch self {
        case .breakfast: return "breakfast-category"
        case .lunch: return "lunch-category"
        case .dinner: return "dinner-category"
        case .bar: return "bar-category"
        case .gallery: return "gallery-category"
        case .sightseeng: return "sightseeing-category"
        case .museums: return "museums-category"
        case .fun: return "fun-category"
        }
    }
    
    var activity: EventType.Activity {
        switch self {
        case .breakfast, .lunch, .dinner: return .food
        case .bar: return .bar
        case .gallery: return .gallery
        case .sightseeng: return .sightseeing
        case .museums: return .museum
        case .fun: return .fun
        }
    }
    
    var id: Int {
        hashValue
    }
}
