//
//  Date+compare.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
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

extension Date {
    
    func startOf(_ dateComponent : Calendar.Component) -> Date {
        var calendar: Calendar = .current
        var startOfComponent = self
        var timeInterval : TimeInterval = 0.0
        calendar.dateInterval(of: dateComponent, start: &startOfComponent, interval: &timeInterval, for: self)
        return startOfComponent
    }
}

extension Date {
    func localizedTimeString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
    }
}

extension TimeInterval {
    
    static var minute: TimeInterval {
        60
    }
    
    static var hour: TimeInterval {
        minute * 60
    }
    
    static var day: TimeInterval {
        hour * 24
    }
}
