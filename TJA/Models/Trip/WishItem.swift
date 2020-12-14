//
//  WishItem.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

enum WishItem: String, Codable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case bar = "Bar"
    case gallery = "Gallery"
    case sightseeng = "Sightseeng"
    case museums = "Museums"
    case fun = "Fun"
    
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
    
    var activity: Activity.Event {
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
