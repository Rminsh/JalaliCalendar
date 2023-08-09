//
//  SmallCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by armin on 2/2/21.
//

import SwiftUI
import WidgetKit

struct SmallCalendarView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.showsWidgetContainerBackground) var showsWidgetBackground
    
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
        VStack(alignment: .center) {
            if showsWidgetBackground && widgetFamily != .systemMedium {
                HStack {
                    weekday
                    month
                }
                .frame(maxWidth: .infinity)
                
                dayNumber
                    .padding(.top, -24)
                    .padding(.bottom, -36)
            } else {
                dayNumber
                    .padding(.top, -24)
                    .padding(.bottom, -36)
                
                HStack {
                    weekday
                    month
                }
            }
            
            HStack(alignment: .center) {
                monthProgress
                    .gaugeStyle(.accessoryLinearCapacity)
                Spacer()
                yearProgress
                    .gaugeStyle(.accessoryLinearCapacity)
            }
            .padding(.bottom, 5)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .containerBackground(.widgetBackground, for: .widget)
    }
    
    var month: some View {
        Text(date, format: formatter.month())
            .customFont(
                style: showsWidgetBackground ? .title3 : .title2,
                weight: .bold
            )
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.65)
            .dynamicTypeSize(.xSmall)
    }
    
    var weekday: some View {
        Text(date, format: formatter.weekday())
            .customFont(
                style: showsWidgetBackground ? .title3 : .title2,
                weight: .bold
            )
            .foregroundStyle(.accent)
            .lineLimit(1)
            .minimumScaleFactor(0.65)
            .dynamicTypeSize(.xSmall)
    }
    
    var dayNumber: some View {
        Text(date, format: formatter.day())
            .font(.custom("Shabnam", size: showsWidgetBackground ? 54 : 64).weight(.bold))
            .dynamicTypeSize(.accessibility5)
            .foregroundStyle(.text)
    }
    
    // MARK: - Year's Progress
    var yearProgress: some View {
        Gauge(value: firstProgress) {
            Text(firstTitle)
                .customFont(style: .callout, weight: .light)
                .foregroundStyle(.text)
        }
        .tint(.accent)
    }
    
    // MARK: - Month's Progress
    var monthProgress: some View {
        Gauge(value: secondProgress) {
            Text(secondTitle)
                .customFont(style: .callout, weight: .light)
                .foregroundStyle(.text)
        }
        .tint(.accent)
    }
}

#Preview(as: .systemSmall) {
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