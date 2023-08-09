//
//  RectangularCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/25/22.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension, introduced: 16.0)
struct RectangularCalendarView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var firstProgress: Float {
        date.daysPassedInYear()
    }
    
    var secondProgress: Float {
        date.daysPassedInMonth()
    }
    
    var firstTitle: String = "سال"
    var secondTitle: String = "ماه"
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Text(date, format: formatter.day())
                    .customFont(style: .title3, weight: .bold)
                Text(date, format: formatter.month())
                    .customFont(style: .title3, weight: .bold)
                Text(date, format: formatter.year())
                    .customFont(style: .title3)
                    .foregroundStyle(.secondary)
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
        .containerBackground(for: .widget) {
            AccessoryWidgetBackground()
        }
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

#Preview(as: .systemSmall) {
    TodayWidget()
} timeline: {
    SimpleEntry(date: .now)
}
