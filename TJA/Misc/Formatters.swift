//
//  Formatters.swift
//  TJA
//
//  Created by Miron Rogovets on 16.11.2020.
//

import Foundation


private let day = 60 * 60 * 24 as TimeInterval
private let week = day * 7 as TimeInterval


final class ExactDateFormatter {
    func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

final class TimeFormatter {
    func fullString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

    func recentString(between date: Date, and now: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1

        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en")
        formatter.calendar = calendar
        let components = calendar.dateComponents([.day],
                                                 from: date,
                                                 to: date <= now ? now : date)

        guard let timeString = formatter.string(for: components) else {
            return nil
        }

        // Bug with maximumUnitCount not working
        guard let commaIndex = timeString.firstIndex(of: ",") else { return timeString }
        return String(timeString[..<commaIndex])
    }
}

final class TimeAgoFormatter {
    func string(from date: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(date)
        if interval < 0 {
            return formatter.fullString(from: date)
        } else if interval < day {
            return "Today"
        } else if let string = formatter.recentString(between: date, and: now) {
            return string + " ago"
        } else {
            return formatter.fullString(from: date)
        }
    }

    private let formatter = TimeFormatter()
}

final class TimeRemainingFormatter {
    func string(from date: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(date)
        if abs(interval) < day { return "Today" }
        let string = formatter.recentString(between: now, and: date) ?? "a day"
        return "in " + string
    }

    private let formatter = TimeFormatter()
}

let dateFormatter = ExactDateFormatter()
let daysAgoFormatter = TimeAgoFormatter()
let daysRemainFormatter = TimeRemainingFormatter()
