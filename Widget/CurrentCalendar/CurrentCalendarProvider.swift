//
//  CurrentCalendarProvider.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 11/28/23.
//

#if os(iOS)
import SwiftUI
import Intents
import WidgetKit

struct CurrentCalendarProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> CurrentCalendarEntry {
        let configuration = CurrentCalendarConfigurationIntent()
        let isPersian = configuration.isPersian?.boolValue
        let showYear = configuration.showYear?.boolValue
        
        return CurrentCalendarEntry(
            date: Date(),
            configuration: configuration,
            isPersian: isPersian,
            showYear: showYear
        )
    }
    
    func getSnapshot(
        for configuration: CurrentCalendarConfigurationIntent,
        in context: Context,
        completion: @escaping (CurrentCalendarEntry) -> Void) {
        let entry = CurrentCalendarEntry(
            date: Date(),
            configuration: configuration,
            isPersian: configuration.isPersian?.boolValue,
            showYear: configuration.showYear?.boolValue
        )
        completion(entry)
    }
    
    func getTimeline(
        for configuration: CurrentCalendarConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<CurrentCalendarEntry>) -> Void) {
            let currentDate = Date()
            let midnight = Calendar.current.startOfDay(for: currentDate)
            let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
            let isPersian = configuration.isPersian?.boolValue
            let showYear = configuration.showYear?.boolValue
            let entries = [
                CurrentCalendarEntry(
                    date: Date(),
                    configuration: configuration,
                    isPersian: isPersian,
                    showYear: showYear
                )
            ]
            
            let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
            completion(timeline)
    }
}
#endif
