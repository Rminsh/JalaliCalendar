//
//  CircularProgressCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/10/23.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension, introduced: 16.0)
struct CircularProgressCalendarView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var daysPassedInMonth: Float {
        date.daysPassedInMonth()
    }
    
    var body: some View {
        ZStack {
            Gauge(value: daysPassedInMonth) {
                EmptyView()
            }
            .tint(.accent)
            .gaugeStyle(.accessoryCircularCapacity)
            
            VStack(spacing: 2) {
                Text(date, format: formatter.day())
                    .customFont(style: .title2, weight: .bold)
                
                Text(date, format: formatter.month())
                    .customFont(style: .caption1, weight: .medium)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.top, -8)
                    .widgetAccentable()
            }
            .padding(.bottom, 4)
        }
        .containerBackground(.widgetBackground, for: .widget)
    }
}

#Preview(as: .systemSmall) {
    ProgressCalendarWidget()
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
