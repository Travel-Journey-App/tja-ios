//
//  SuggestionPlace.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

struct SuggestionPlace: Hashable, Codable, Identifiable {
    
    enum Price: String, Codable {
        case cheap, medium, expensive
    }
    
    let id: Int
    let name: String
    let description: String
    let rating: Double
    let price: Price?
    
    var ratingString: String {
        return "\(rating.round(to: 1))"
    }
    
    var cost: String {
        switch price {
        case .none: return ""
        case .cheap: return "$"
        case .medium: return "$$"
        case .expensive: return "$$$"
        }
    }
}
