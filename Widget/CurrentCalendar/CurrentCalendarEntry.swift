//
//  CurrentCalendarEntry.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 11/28/23.
//

#if os(iOS)
import SwiftUI
import WidgetKit

struct CurrentCalendarEntry: TimelineEntry {
    let date: Date
    let configuration: CurrentCalendarConfigurationIntent
    let isPersian: Bool?
    let showYear: Bool?
}
#endif
