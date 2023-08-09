//
//  Provider.swift
//  JalaliCalendar
//
//  Created by Armin on 2/8/23.
//

import SwiftUI
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [
            SimpleEntry(date: Date())
        ]
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}
