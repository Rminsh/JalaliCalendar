//
//  MonthView.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import SwiftUI

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let month: Date
    let showHeader: Bool
    let content: (Date) -> DateView

    init(
        month: Date,
        showHeader: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
        self.showHeader = showHeader
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        
        /// Force the calendar header to show persian calendar in farsi
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa")
        
        return Text(formatter.string(from: month))
            .font(.custom("Shabnam-Bold", size: 28))
            .padding()
    }

    var body: some View {
        VStack(spacing: 3) {
            if showHeader {
                header
            }

            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}
