//
//  RectangularProgressCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/10/23.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension, introduced: 16.0)
struct RectangularProgressCalendarView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    
    var firstTitle: String = "سال"
    var secondTitle: String = "ماه"
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var firstProgress: Float {
        date.daysPassedInYear()
    }
    
    var secondProgress: Float {
        date.daysPassedInMonth()
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
        VStack {
            HStack(spacing: 4) {
                Text(date, format: formatter.day())
                    .customFont(style: .title3, weight: .bold)
                    .contentTransition(.numericText())
                Text(date, format: formatter.month())
                    .customFont(style: .title3, weight: .bold)
                    .id(date.formatted(.dateTime.month()))
                    .transition(.push(from: .bottom))
                    .animation(.smooth, value: date)
                Text(date, format: formatter.year())
                    .customFont(style: .title3)
                    .foregroundStyle(.secondary)
                    .id(date.formatted(.dateTime.year()))
                    .transition(.push(from: .bottom))
                    .animation(.smooth, value: date)
            }
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                monthProgress
                yearProgress
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    // MARK: - Year's Progress
    var yearProgress: some View {
        Gauge(value: firstProgress) {
            Text(firstTitle)
                .customFont(style: .caption1, weight: .light)
        }
        .gaugeStyle(.accessoryLinearCapacity)
    }
    
    // MARK: - Month's Progress
    var monthProgress: some View {
        Gauge(value: secondProgress) {
            Text(secondTitle)
                .customFont(style: .caption1, weight: .light)
        }
        .gaugeStyle(.accessoryLinearCapacity)
    }
}

#if os(iOS)
@available(iOS 17.0, macOS 14.0, *)
#Preview(as: .accessoryRectangular) {
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
#endif
