//
//  CircularProgressCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/10/23.
//

import SwiftUI
import WidgetKit

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
        Group {
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                content
                    .containerBackground(.widgetBackground, for: .widget)
            } else {
                content
            }
        }
    }
    
    var content: some View {
        ZStack {
            Gauge(value: daysPassedInMonth) {
                EmptyView()
            }
            .tint(.accent)
            .gaugeStyle(.accessoryCircularCapacity)
            
            VStack(spacing: 2) {
                Text(date, format: formatter.day())
                    .font(.customFont(style: .title2, weight: .bold))
                    .contentTransition(.numericText())
                
                Text(date, format: formatter.month())
                    .font(.customFont(style: .caption1, weight: .medium))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.top, -8)
                    .widgetAccentable()
                    .id(date.formatted(.dateTime.month()))
                    .transition(.push(from: .bottom))
                    .animation(.smooth, value: date)
            }
            .padding(.bottom, 4)
        }
    }
}

#if os(iOS)
@available(iOS 17.0, *)
#Preview(as: .accessoryCircular) {
    ProgressCalendarWidget()
} timeline: {
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 6))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 5))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 4))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 3))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 2))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 1))
    SimpleEntry(date: .now)
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 6))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 5))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 4))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 3))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 2))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 1))
}
#endif
