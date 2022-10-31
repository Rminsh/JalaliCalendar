//
//  CalendarWidget.swift
//  CalendarWidget
//
//  Created by armin on 1/28/21.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let entry = WidgetEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [
            WidgetEntry(date: Date())
        ]
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
}

struct CalendarWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        
        switch widgetFamily {
        case .systemSmall:
            SmallCalendarView(date: entry.date)
                .padding(.horizontal, 8)
                .background(Color("WidgetBackground"))
        case .systemMedium:
            MediumCalendarView(date: entry.date)
                .background(Color("WidgetBackground"))
        #if os(iOS)
        case .accessoryCircular:
            CircularCalendarView(
                month: JalaliHelper.MonthFa.string(from: entry.date),
                dayNumber: JalaliHelper.DayFa.string(from: entry.date)
            )
        case .accessoryInline:
            Text("\(JalaliHelper.MonthFa.string(from: entry.date)) \(JalaliHelper.DayFa.string(from: entry.date))، \(JalaliHelper.DayWeekFa.string(from: entry.date))")
        case .accessoryRectangular:
            RectangularCalendarView(
                today: entry.date,
                event: EventService.shared.getEvent(currentDate: entry.date)
            )
        #endif
        default:
            Text(JalaliHelper.DayFa.string(from: entry.date))
        }
        
    }
}

@main
struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"
    
    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return StaticConfiguration(kind: kind, provider: Provider()) { entry in
                CalendarWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Jalali Calendar")
            .description("Check today's jalali date")
            #if os(iOS)
            .supportedFamilies([
                .systemSmall,
                .systemMedium,
                .accessoryCircular,
                .accessoryInline,
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
                CalendarWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Jalali Calendar")
            .description("Check today's jalali date")
            .supportedFamilies([.systemSmall, .systemMedium])
        }
    }
}

struct CalendarWidget_Previews: PreviewProvider {
    
    static let date = Date().addingTimeInterval(-60 * 60 * 24 * 0)
    
    static var previews: some View {
        CalendarWidgetEntryView(entry: WidgetEntry(date: date))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
