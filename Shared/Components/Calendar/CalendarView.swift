//
//  CalendarView.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import SwiftUI

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let content: (Date) -> DateView

    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        VStack {
            ForEach(months, id: \.self) { month in
                MonthView(month: month, content: self.content)
            }
        }
    }
}
