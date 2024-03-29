//
//  MonthWidget.swift
//  JalaliCalendar
//
//  Created by Armin on 2/9/23.
//

import SwiftUI
import WidgetKit

struct MonthWidgetEntryView: View {
    
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallMonthView(date: entry.date)
        case .systemMedium:
            MediumMonthView(date: entry.date)
        #if os(iOS)
        case .accessoryRectangular:
            RectangularMonthView(date: entry.date)
        #endif
        default:
            Text(entry.date, format: .dateTime.year().month().day())
        }
    }
}

struct MonthWidget: Widget {
    let kind: String = "MonthWidget"
    
    #if os(iOS)
    let families: [WidgetFamily] = [
        .systemSmall,
        .systemMedium,
        .accessoryRectangular,
    ]
    #elseif os(macOS)
    let families: [WidgetFamily] = [
        .systemSmall,
        .systemMedium
    ]
    #endif
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MonthWidgetEntryView(entry: entry)
                .privacySensitive(false)
                .environment(\.calendar, .persianCalendar)
                .environment(\.locale, .init(identifier: "fa"))
        }
        .configurationDisplayName("Month")
        .description("Track the day of the month in jalali calendar")
        .supportedFamilies(families)
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview(as: .systemSmall) {
    MonthWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 31))
}
