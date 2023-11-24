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
    
    @State private var events = CalendarEvents.persianCalendarEvents
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.showsWidgetContainerBackground) var showsWidgetBackground
    
    var body: some View {
        Group {
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                SmallCalendarContentView(date: date)
                    .containerBackground(.widgetBackground, for: .widget)
            } else {
                SmallCalendarContentView(date: date)
                    .padding(.vertical)
                    .padding(.horizontal, 5)
                    .scaleEffect(0.9)
                    .background(.widgetBackground)
            }
        }
    }
}

struct SmallCalendarContentView: View {
    
    var date: Date
    
    @State private var events = CalendarEvents.persianCalendarEvents
    
    @Environment(\.calendar) var calendar
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.showsWidgetContainerBackground) var showsWidgetBackground
    
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
    
    var dayNumberFont: UXFont.TextStyle {
        #if os(iOS)
        if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
            return showsWidgetBackground ? .largeTitle : .extraLargeTitle
        } else {
            return .largeTitle
        }
        #else
        return .largeTitle
        #endif
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            dayNumber
                .contentTransition(.numericText())
                #if os(iOS)
                .padding(.top, 21)
                #endif
            VStack(alignment: .leading, spacing: 5) {
                month
                    .id(date.formatted(.dateTime.month()))
                    .transition(.push(from: .bottom))
                event
                    .frame(height: 18)
                    .id(currentDateEvents.first?.day)
                    .transition(.push(from: .bottom))
                    .animation(.smooth, value: currentDateEvents.first?.day)
                    .padding(.top, -2)
                    .padding(.bottom, 8)
            }
            #if os(iOS)
            .padding(.top, -32)
            .padding(.bottom, -8)
            #endif
            
            HStack(alignment: .center) {
                monthProgress
                    .gaugeStyle(.accessoryCircularCapacity)
                    .scaleEffect(0.8)
                    .padding(.all, -6)
                
                Spacer()
                
                yearProgress
                    .gaugeStyle(.accessoryCircularCapacity)
                    .scaleEffect(0.8)
                    .padding(.all, -6)
            }
            #if os(iOS)
            .padding(.bottom, 24)
            #endif
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    var month: some View {
        Text(date, format: formatter.month())
            .customFont(
                style: showsWidgetBackground ? .title1 : .largeTitle,
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
            .customFont(style: dayNumberFont, weight: .bold)
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
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 1))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 2))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 3))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 4))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 5))
}
