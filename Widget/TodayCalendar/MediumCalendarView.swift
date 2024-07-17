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
        Group {
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                content
                    .containerBackground(.widgetBackground, for: .widget)
            } else {
                content
                    .padding(.horizontal, 12)
                    .background(.widgetBackground)
            }
        }
    }
    
    var content: some View {
        HStack(spacing: 10) {
            // MARK: - Today View
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                SmallCalendarContentView(date: date)
            } else {
                SmallCalendarContentView(date: date)
                    .scaleEffect(0.9)
            }
            
            // MARK: - Calendar Month View
            MonthView(month: date) { weekday in
                Text(weekday)
                    .font(.customFont(style: .caption2))
                    .foregroundStyle(weekday == "ج" ? .secondary : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 2)
            } content: { dateItem in
                let isToday: Bool = dateItem.checkIsToday(date: date)
                textDate(dateItem)
                    .foregroundStyle(isToday ? .clear : dateItem.isSaturday() ? .secondary : .primary)
                    .background {
                        Circle()
                            .fill(isToday ? Color.accent: Color.clear)
                            .widgetAccentable()
                            .reverseMask {
                                textDate(dateItem)
                            }
                            .padding(-2)
                    }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
    }
    
    @ViewBuilder
    func textDate(_ date: Date) -> some View {
        Text(date, format: formatter.day())
            #if os(macOS)
            .font(.customFont(style: .callout))
            #else
            .font(.customFont(style: .caption2))
            #endif
            .lineLimit(1)
            .minimumScaleFactor(0.9)
            .dynamicTypeSize(.xSmall)
            .frame(maxWidth: .infinity)
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview(as: .systemMedium) {
    TodayWidget()
} timeline: {
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 6))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 5))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 4))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 3))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 2))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 1))
    SimpleEntry(date: .now)
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 1))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 2))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 3))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 4))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 5))
}
