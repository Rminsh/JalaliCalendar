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
    
    @WidgetBundleBuilder
    var body: some Widget {
        CalendarWidget()
        MonthWidget()
    }
}
