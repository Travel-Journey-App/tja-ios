//
//  Date+compare.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//

import Foundation


extension Date {
    
    func compare(to date: Date, resultIn component: Calendar.Component = .day, calendar: Calendar = .current) -> ComparisonResult {
        calendar.compare(self, to: date, toGranularity: component)
    }

    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func isToday(_ calendar: Calendar = .current) -> Bool {
        return calendar.isDateInToday(self)
    }
    
    func isYesterday(_ calendar: Calendar = .current) -> Bool {
        return calendar.isDateInYesterday(self)
    }
    
    func isTomorrow(_ calendar: Calendar = .current) -> Bool {
        return calendar.isDateInTomorrow(self)
    }
}
