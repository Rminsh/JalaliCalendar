//
//  MediumCalendarView.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import SwiftUI
import WidgetKit

struct MediumCalendarView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            // MARK: - Today View
            SmallCalendarView(date: date)
            
            // MARK: - Calendar Month View
            MonthView(month: date) { weekday in
                Text(weekday)
                    .customFont(style: .caption2)
                    .foregroundStyle(weekday == "ج" ? .secondary : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 2)
            } content: { dateItem in
                Text(dateItem, format: formatter.day())
                    .customFont(style: .caption2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 2)
                    .foregroundStyle(
                        dateItem.checkIsToday(date: date) ?
                        .white :
                        dateItem.isSaturday() ? .secondary : .primary
                    )
                    .background {
                        Circle()
                            .fill(
                                dateItem.checkIsToday(date: date) ?
                                Color("AccentColor") :
                                Color.clear
                            )
                    }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
        .containerBackground(.widgetBackground, for: .widget)
    }
}

#Preview(as: .systemMedium) {
    TodayWidget()
} timeline: {
    SimpleEntry(date: .now)
}