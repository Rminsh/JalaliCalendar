//
//  Extensions+Date.swift
//  CalendarWidgetExtension
//
//  Created by armin on 2/2/21.
//

import Foundation

extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    
    func daysPassedInMonth() -> Float {
        let calendar = Calendar(identifier: .persian)
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let totalDays = range.count
        let passedDays = self.days(from: date)
        return Float(passedDays)/Float(totalDays)
    }
    
    func daysPassedInYear() -> Float {
        let calendar = Calendar(identifier: .persian)
        let dateComponents = DateComponents(year: calendar.component(.year, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .year, for: date)!
        let totalDays = range.count
        let passedDays = self.days(from: date)
        return Float(passedDays)/Float(totalDays)
    }
    
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
    
    func checkIsToday(date: Date) -> Bool {
        return hasSame(.day, as: date) && hasSame(.month, as: date) && hasSame(.year, as: date)
    }
    
    func isSaturday() -> Bool {
        Calendar.current.dateComponents([.weekday], from: self).weekday == 6
    }
}

public extension Date {
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar(identifier: .persian)
        return calendar.date(byAdding: component, value: value, to: self)!
    }
}
