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
        case .accessoryCircular:
            CircularCalendarView(
                day: JalaliHelper.DayWeekFa.string(from: entry.date),
                dayNumber: JalaliHelper.DayFa.string(from: entry.date)
            )
        case .accessoryInline:
            Text("\(JalaliHelper.MonthFa.string(from: entry.date)) \(JalaliHelper.DayFa.string(from: entry.date))، \(JalaliHelper.DayWeekFa.string(from: entry.date))")
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
            .supportedFamilies([
                .systemSmall,
                .systemMedium,
                .accessoryCircular,
                .accessoryInline
            ])
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
        CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
