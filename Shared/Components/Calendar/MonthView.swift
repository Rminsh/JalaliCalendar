//
//  MonthView.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import SwiftUI

struct MonthView<WeekDaysView: View, DateView: View>: View {
    
    @Environment(\.calendar) var calendar

    let month: Date
    let showHeader: Bool
    let onlySummary: Bool
    let weekdays: (String) -> WeekDaysView
    let content: (Date) -> DateView

    init(
        month: Date,
        showHeader: Bool = true,
        onlySummary: Bool = false,
        @ViewBuilder weekdays: @escaping (String) -> WeekDaysView,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.weekdays = weekdays
        self.content = content
        self.showHeader = showHeader
        self.onlySummary = onlySummary
    }

    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    private var summaryWeeks: [Date] {
        if weeks.count < 4 {
            return weeks /// Should never ever happen!
        }
        
        switch currentWeekIndex {
        case 0:
            return Array(weeks.prefix(3))
        case _ where currentWeekIndex == weeks.count - 1:
            return Array(weeks.suffix(3))
        default:
            return [weeks[currentWeekIndex - 1], weeks[currentWeekIndex], weeks[currentWeekIndex + 1]]
        }
        
    }
    
    private var currentWeekIndex: Int {
        for (index, week) in weeks.enumerated() {
            if index == weeks.count - 1 { /// Last index
                return index
            }
            
            if (week ... weeks[weeks.count - 1 < index + 1 ? index : index + 1]).contains(month) {
                return index
            }
        }
        
        return 0
    }
    
    private var weekdaysSymbols: [String] {
        var calendar = Calendar(identifier: .persian)
        calendar.locale = Locale(identifier: "fa")
        return calendar.veryShortStandaloneWeekdaySymbols.shifted(by: 1)
    }

    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        
        /// Force the calendar header to show persian calendar in farsi
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa")
        
        return Text(formatter.string(from: month))
            .customFont(style: .callout, weight: .bold)
            .foregroundColor(Color("AccentColor"))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: onlySummary ? 0 : 3) {
            if showHeader {
                header
                    .padding(.bottom, 2)
            }
            
            HStack {
                ForEach(weekdaysSymbols, id: \.self) { day in
                    self.weekdays(day)
                }
            }

            ForEach(onlySummary ? summaryWeeks : weeks , id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}
