//
//  CircularCalendarView.swift
//  JalaliCalendar
//
//  Created by Armin on 8/25/22.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension, introduced: 16.0)
struct CircularCalendarView: View {
    
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
            }
        }
    }
    
    var content: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 0) {
                Text(date, format: formatter.day())
                    .font(.customFont(style: .title1, weight: .bold))
                    .contentTransition(.numericText())
                
                Text(date, format: formatter.month())
                    .font(.customFont(style: .callout, weight: .medium))
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
#endif
