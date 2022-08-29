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
            SmallCalendarView(
                day: JalaliHelper.DayFa.string(from: entry.date),
                month: JalaliHelper.MonthFa.string(from: entry.date),
                event: EventService.shared.getEvent(),
                firstProgress: entry.date.daysPassedInYear(),
                firstTitle: "سال",
                secondProgress: entry.date.daysPassedInMonth(),
                secondTitle: "ماه")
                .padding(.vertical)
                .background(Color("WidgetBackground"))
        case .systemMedium:
            MediumCalendarView(
                day: JalaliHelper.DayFa.string(from: entry.date),
                month: JalaliHelper.MonthFa.string(from: entry.date),
                event: EventService.shared.getEvent(),
                firstProgress: entry.date.daysPassedInYear(),
                firstTitle: "سال",
                secondProgress: entry.date.daysPassedInMonth(),
                secondTitle: "ماه")
                .padding(.all)
                .background(Color("WidgetBackground"))
        #if os(iOS)
        case .accessoryCircular:
            CircularCalendarView(
                day: JalaliHelper.DayWeekFa.string(from: entry.date),
                dayNumber: JalaliHelper.DayFa.string(from: entry.date)
            )
        case .accessoryInline:
            Text("\(JalaliHelper.MonthFa.string(from: entry.date)) \(JalaliHelper.DayFa.string(from: entry.date))، \(JalaliHelper.DayWeekFa.string(from: entry.date))")
        case .accessoryRectangular:
            RectangularCalendarView(
                today: entry.date,
                event: EventService.shared.getEvent()
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
    static var previews: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
                #if os(iOS)
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                #elseif os(macOS)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                #endif
        } else {
            CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
