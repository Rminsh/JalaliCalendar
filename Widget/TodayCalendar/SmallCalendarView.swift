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
    
    @State var events = CalendarEvents.persianCalendarEvents
    
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
    
    var calendarComponents: DateComponents {
        return Calendar.persianCalendar.dateComponents(
            [.day, .year, .month],
            from: date
        )
    }
    
    var currentDateEvents: [EventDetails] {
        return events.filter { item in
            item.day == calendarComponents.day &&
               item.month == calendarComponents.month
        }
    }
    
    var firstTitle: String = "سال"
    var secondTitle: String = "ماه"
    
    var body: some View {
        VStack(alignment: .leading) {
            dayNumber
                .padding(.top, 25)
            VStack(alignment: .leading, spacing: 5) {
                month
                event
            }
            .padding(.top, -32)
            .padding(.bottom, -8)
            
            HStack(alignment: .center) {
                monthProgress
                    .gaugeStyle(.accessoryCircularCapacity)
                    .scaleEffect(0.8)
                Spacer()
                    .frame(maxWidth: 12)
                yearProgress
                    .gaugeStyle(.accessoryCircularCapacity)
                    .scaleEffect(0.8)
            }
            .padding(.bottom, 24)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .containerBackground(.widgetBackground, for: .widget)
    }
    
    var month: some View {
        Text(date, format: formatter.month())
            .customFont(
                style: .title1,
                weight: .bold
            )
            .foregroundStyle(.accent)
            
            .lineLimit(1)
            .minimumScaleFactor(0.65)
            .dynamicTypeSize(.xSmall)
    }
    
    var event: some View {
        Text(currentDateEvents.first?.title ?? "بدون مناسبت")
            .customFont(
                style: .footnote,
                weight: .light
            )
            .foregroundStyle(.text)
            .lineLimit(1)
            .minimumScaleFactor(0.65)
            .dynamicTypeSize(.xSmall)
    }
    
    var dayNumber: some View {
        Text(date, format: formatter.day())
            .customFont(style: .largeTitle, weight: .bold)
            .dynamicTypeSize(.large)
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
