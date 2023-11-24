//
//  Calendar+Extensions.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import Foundation

extension Calendar {
    static var persianCalendar: Calendar {
        var calendar = Calendar(identifier: .persian)
        calendar.locale = Locale(identifier: "fa")
        return calendar
    }
    
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}
