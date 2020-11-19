//
//  Formatters.swift
//  TJA
//
//  Created by Miron Rogovets on 16.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


private let day = 60 * 60 * 24 as TimeInterval


protocol DateFormatting {
    var dateFormat: String { get }
    func string(from date: Date) -> String
}

protocol TimeFormatting {
    func recentString(between date: Date, and now: Date) -> String?
}


final class ExactDateFormatter: DateFormatting {
    
    let dateFormat: String
    
    init(dateFormat: String = "dd.MM.yyyy") {
        self.dateFormat = dateFormat
    }
    
    func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = self.dateFormat
        return formatter.string(from: date)
    }
}

final class TimeFormatter: TimeFormatting {

    func recentString(between date: Date, and now: Date) -> String? {
        guard let distance = now.fullDistance(from: date, resultIn: .day) else { return nil }
        
        if distance == 0 {
            return "Today"
        }
        
        let postfix = abs(distance) <= 1 ? "" : "s"
        if distance < 0 {
            return "\(abs(distance)) day\(postfix) ago"
        } else {
            return "in \(distance) day\(postfix)"
        }
    }
}


let dateFormatter = ExactDateFormatter()
let slashedFormatter = ExactDateFormatter(dateFormat: "dd/MM/yyyy")
let remainingOrAgoFormatter = TimeFormatter()
