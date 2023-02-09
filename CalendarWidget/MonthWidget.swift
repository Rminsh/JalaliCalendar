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
                .background(Color("WidgetBackground"))
        case .systemMedium:
            MediumMonthView(date: entry.date)
                .background(Color("WidgetBackground"))
        #if os(iOS)
        case .accessoryRectangular:
            RectangularMonthView(today: entry.date)
        #endif
        default:
            Text(JalaliHelper.DayFa.string(from: entry.date))
        }
    }
}

struct MonthWidget: Widget {
    let kind: String = "MonthWidget"
    
    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return StaticConfiguration(kind: kind, provider: Provider()) { entry in
                MonthWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Month")
            .description("Track the day of the month in jalali calendar")
            #if os(iOS)
            .supportedFamilies([
                .systemSmall,
                .systemMedium,
                .accessoryRectangular
            ])
            #elseif os(macOS)
            .supportedFamilies([
                .systemSmall,
                .systemMedium
            ])
            #endif
        } else {
            return StaticConfiguration(kind: kind, provider: Provider()) { entry in
                MonthWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Month")
            .description("Track the day of the month in jalali calendar")
            .supportedFamilies([.systemSmall, .systemMedium])
        }
    }
}

struct MonthOverviewWidget_Previews: PreviewProvider {
    
    static let date = Date().addingTimeInterval(-60 * 60 * 24 * 0)
    
    static var previews: some View {
        MonthWidgetEntryView(entry: WidgetEntry(date: date))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
