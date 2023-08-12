//
//  RectangularCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/25/22.
//

import SwiftUI
import WidgetKit

@available(iOS, introduced: 16.0)
struct RectangularCalendarView: View {
    
    var date: Date
    
    @State private var events = CalendarEvents.persianCalendarEvents
    
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
        HStack {
            Capsule()
                .frame(width: 4)
                .widgetAccentable()
            
            VStack(alignment: .leading) {
                HStack(spacing: 3) {
                    Text(date, format: formatter.weekday())
                        .customFont(style: .body, weight: .bold)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .id(date.formatted(.dateTime.weekday()))
                        .transition(.push(from: .bottom))
                        .animation(.smooth, value: currentDateEvents.first?.day)
                        
                    
                    Text(date, format: formatter.day())
                        .customFont(style: .body, weight: .bold)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .contentTransition(.numericText(value: date.timeIntervalSince1970))
                    
                    Text(date, format: formatter.month())
                        .customFont(style: .body, weight: .bold)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .id(date.formatted(.dateTime.month()))
                        .transition(.push(from: .bottom))
                        .animation(.smooth, value: currentDateEvents.first?.day)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(currentDateEvents.first?.title ?? "بدون مناسبت")
                    .customFont(style: .body, weight: .light)
                    .id(currentDateEvents.first?.day)
                    .transition(.push(from: .bottom))
                    .animation(.smooth, value: currentDateEvents.first?.day)
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

#if os(iOS)
#Preview(as: .accessoryRectangular) {
    TodayWidget()
} timeline: {
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 6))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 5))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 4))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 3))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 2))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 1))
    SimpleEntry(date: .now)
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 1 * 30))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 2 * 30))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 3 * 30))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 4 * 30))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 5 * 30))
}
#endif
