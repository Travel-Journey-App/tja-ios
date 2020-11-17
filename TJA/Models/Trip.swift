//
//  Trip.swift
//  TJA
//
//  Created by Miron Rogovets on 16.11.2020.
//

import Foundation

struct Trip: Hashable, Codable, Identifiable {
    let id: Int
    let image: URL?
    let name: String
    let startDate: Date
    let endDate: Date
    
    var isFinished: Bool {
        return Date() > endDate
    }
    
    var hasStarted: Bool {
        return Date() >= startDate
    }
    
    var daysInOrAgo: String {
        if isFinished {
            return daysAgoFormatter.string(from: endDate)
        } else if hasStarted {
            return "Today"
        } else {
            return daysRemainFormatter.string(from: startDate)
        }
    }
    
    var interval: String {
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
}
