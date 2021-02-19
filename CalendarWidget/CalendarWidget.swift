//
//  CalendarWidget.swift
//  CalendarWidget
//
//  Created by armin on 1/28/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let entry = WidgetEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        /*
         var entries = [SimpleEntry]()
         let currentDate = Date()
         let midnight = Calendar.current.startOfDay(for: currentDate)
         let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
         
         for offset in 0 ..< 60 * 24 {
         let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: midnight)!
         entries.append(SimpleEntry(date: entryDate))
         }
         
         let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
         completion(timeline)
         */
        
        /** ⚠️ It seems like this update method should work
         If at any time it encountered a problem use the above method
         The above method is refreshing the widget every minute (Against Apple's policy for 15 min updates)
         */
        
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
            
        default:
            Text(JalaliHelper.DayFa.string(from: entry.date))
        }
        
    }
}

@main
struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Jalali Calendar")
        .description("Check today's jalali date")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct CalendarWidget_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
