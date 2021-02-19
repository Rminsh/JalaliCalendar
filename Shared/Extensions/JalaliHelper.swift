//
//  JalaliHelper.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import Foundation

class JalaliHelper {
    
    static let DayEn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.calendar = Calendar(identifier: .persian)
        
        return formatter
    }()
    
    static let DayFa: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa")
        
        return formatter
    }()
    
    static let DayWeekFa: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa")
        
        return formatter
    }()
    
    static let MonthEn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        formatter.calendar = Calendar(identifier: .persian)
        
        return formatter
    }()
    
    static let MonthFa: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa")
        
        return formatter
    }()
    
    static let YearFa: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa")
        
        return formatter
    }()
}
