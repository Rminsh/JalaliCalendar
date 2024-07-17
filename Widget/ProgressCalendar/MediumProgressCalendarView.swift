//
//  MediumProgressCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/10/23.
//

import SwiftUI
import WidgetKit

struct MediumProgressCalendarView: View {
    
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
                    .padding()
                    .background(.widgetBackground)
            }
        }
    }
    
    var content: some View {
        HStack(spacing: 10) {
            // MARK: - Today View
            SmallProgressCalendarContentView(date: date)
            
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
                Text(dateItem, format: formatter.day())
                    .font(.customFont(style: .caption2))
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
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview(as: .systemMedium) {
    ProgressCalendarWidget()
} timeline: {
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 6))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 5))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 4))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 3))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 2))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 1))
    SimpleEntry(date: .now)
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 1))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 2))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 3))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 4))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 5))
}
