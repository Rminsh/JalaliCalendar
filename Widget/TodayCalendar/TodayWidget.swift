//
//  TodayWidget.swift
//  JalaliCalendar
//
//  Created by armin on 1/28/21.
//

import SwiftUI
import WidgetKit

struct TodayWidgetEntryView: View {
    
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.calendar) var calendar
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallCalendarView(date: entry.date)
        case .systemMedium:
            MediumCalendarView(date: entry.date)
        #if os(iOS)
        case .accessoryCircular:
            CircularCalendarView(date: entry.date)
        case .accessoryRectangular:
            RectangularCalendarView(date: entry.date)
        case .accessoryInline:
            Text(entry.date, format: formatter.year().month().day())
        #endif
        default:
            Text(entry.date, format: formatter.year().month().day())
        }
    }
}

struct TodayWidget: Widget {
    let kind: String = "CalendarWidget"
    
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
            TodayWidgetEntryView(entry: entry)
                .privacySensitive(false)
                .environment(\.calendar, .persianCalendar)
                .environment(\.locale, .init(identifier: "fa"))
        }
        .configurationDisplayName("Jalali Calendar")
        .description("Check today's jalali date")
        .supportedFamilies(families)
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview(as: .systemSmall) {
    TodayWidget()
} timeline: {
    SimpleEntry(date: .now)
}
