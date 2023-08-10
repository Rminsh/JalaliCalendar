//
//  ProgressCalendarWidget.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/10/23.
//

import SwiftUI
import WidgetKit

struct ProgressCalendarWidgetEntryView: View {
    
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.calendar) var calendar
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallProgressCalendarView(date: entry.date)
        case .systemMedium:
            MediumProgressCalendarView(date: entry.date)
        #if os(iOS)
        case .accessoryCircular:
            CircularProgressCalendarView(date: entry.date)
        case .accessoryRectangular:
            RectangularProgressCalendarView(date: entry.date)
        #endif
        default:
            Text(entry.date, format: .dateTime.year().month().day())
        }
    }
}

struct ProgressCalendarWidget: Widget {
    let kind: String = "ProgressCalendarWidget"
    
    #if os(iOS)
    let families: [WidgetFamily] = [
        .systemSmall,
        .systemMedium,
        .accessoryCircular,
        .accessoryRectangular
    ]
    #elseif os(macOS)
    let families: [WidgetFamily] = [
        .systemSmall,
        .systemMedium
    ]
    #endif
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ProgressCalendarWidgetEntryView(entry: entry)
                .privacySensitive(false)
                .environment(\.calendar, .persianCalendar)
                .environment(\.locale, .init(identifier: "fa"))
        }
        .configurationDisplayName("Date Progress")
        .description("Check today's jalali date")
        .supportedFamilies(families)
    }
}

#Preview(as: .systemSmall) {
    ProgressCalendarWidget()
} timeline: {
    SimpleEntry(date: .now)
}
