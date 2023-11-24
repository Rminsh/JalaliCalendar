//
//  RectangularMonthView.swift
//  JalaliCalendar
//
//  Created by Armin on 2/10/23.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension, introduced: 16.0)
struct RectangularMonthView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var body: some View {
        Group {
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                content
                    .containerBackground(for: .widget) {
                        AccessoryWidgetBackground()
                    }
            } else {
                content
            }
        }
    }
    
    var content: some View {
        MonthView(month: date, onlySummary: true) { weekday in
            Text(weekday)
                .customFont(style: .caption2, weight: .bold)
                .foregroundStyle(weekday == "ج" ? .secondary : .primary)
                .lineLimit(1)
                .dynamicTypeSize(.xSmall)
                .frame(maxWidth: .infinity)
        } content: { dateItem in
            textDate(dateItem)
                .foregroundStyle(
                    dateItem.checkIsToday(date: date) ?
                    .clear :
                    dateItem.isSaturday() ?
                    .secondary :
                    .primary
                )
                .foregroundStyle(
                    dateItem.isSaturday() &&
                    !dateItem.checkIsToday(date: date) ?
                    .secondary :
                    .primary
                )
                .background {
                    if dateItem.checkIsToday(date: date) {
                        Circle()
                            .widgetAccentable()
                            .reverseMask {
                                textDate(dateItem)
                            }
                    }
                }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
    }
    
    @ViewBuilder
    func textDate(_ date: Date) -> some View {
        Text(date, format: formatter.day())
            .customFont(style: .footnote, weight: .bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .dynamicTypeSize(.xSmall)
            .frame(maxWidth: .infinity)
    }
}

#if os(iOS)
#Preview(as: .accessoryRectangular) {
    MonthWidget()
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
#endif
