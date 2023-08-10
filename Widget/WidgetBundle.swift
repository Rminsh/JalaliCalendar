//
//  WidgetBundle.swift
//  JalaliCalendar
//
//  Created by Armin on 2/8/23.
//

import SwiftUI
import WidgetKit

@main
struct WidgetsBudle: WidgetBundle {
    var body: some Widget {
        TodayWidget()
        MonthWidget()
        ProgressCalendarWidget()
    }
}
