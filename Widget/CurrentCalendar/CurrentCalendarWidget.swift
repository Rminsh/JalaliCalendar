//
//  CurrentCalendarWidget.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 11/28/23.
//

#if os(iOS)
import SwiftUI
import WidgetKit

struct CurrentCalendarWidgetEntryView: View {
    
    var entry: CurrentCalendarEntry
    
    @Environment(\.calendar) var calendar
    @Environment(\.widgetFamily) var widgetFamily
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var isPersian: Bool {
        entry.isPersian ?? true
    }
    
    var dateFormat: Date.FormatStyle {
        if entry.showYear ?? true {
            return formatter.year().month().day()
        } else {
            return formatter.month().day()
        }
    }
    
    var body: some View {
        Group {
            Text(entry.date, format: dateFormat)
        }
        .environment(\.locale, .init(identifier: isPersian ? "fa" : "en"))
    }
}

struct CurrentCalendarWidget: Widget {
    let kind: String = "CurrentCalendarWidget"
    
    
    let families: [WidgetFamily] = [
        .accessoryInline
    ]
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: CurrentCalendarConfigurationIntent.self,
            provider: CurrentCalendarProvider()
        ) { entry in
            CurrentCalendarWidgetEntryView(entry: entry)
                .privacySensitive(false)
                .environment(\.calendar, .persianCalendar)
        }
        .configurationDisplayName("Jalali Calendar")
        .description("Check today's jalali date")
        .supportedFamilies(families)
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview(as: .systemSmall) {
    CurrentCalendarWidget()
} timeline: {
    SimpleEntry(date: .now)
}
#endif
