//
//  SmallProgressCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/10/23.
//

import SwiftUI
import WidgetKit

struct SmallProgressCalendarView: View {
    var date: Date
    
    var body: some View {
        Group {
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                SmallProgressCalendarContentView(date: date)
                    .containerBackground(.widgetBackground, for: .widget)
            } else {
                SmallProgressCalendarContentView(date: date)
                    .padding()
                    .background(.widgetBackground)
            }
        }
    }
}

struct SmallProgressCalendarContentView: View {
    
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
            .id(date.formatted(.dateTime.month()))
            .transition(.push(from: .top))
            .animation(.smooth, value: date)
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
            .id(date.formatted(.dateTime.weekday()))
            .transition(.push(from: .top))
            .animation(.smooth, value: date)
    }
    
    var dayNumber: some View {
        Text(date, format: formatter.day())
            .font(.custom("Shabnam", size: showsWidgetBackground ? 54 : 64).weight(.bold))
            .dynamicTypeSize(.accessibility5)
            .foregroundStyle(.text)
            .contentTransition(.numericText())
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
