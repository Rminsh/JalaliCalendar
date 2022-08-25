//
//  RectangularCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/25/22.
//

import SwiftUI
import WidgetKit

struct RectangularCalendarView: View {
    
    var today: Date
    var event: String
    
    var body: some View {
        HStack {
            if #available(iOSApplicationExtension 16.0, *) {
                Capsule()
                    .frame(width: 4)
                    .widgetAccentable()
            }
            
            VStack(alignment: .leading) {
                Text("\(JalaliHelper.MonthFa.string(from: today)) \(JalaliHelper.DayFa.string(from: today))، \(JalaliHelper.DayWeekFa.string(from: today))")
                    .customFont(name: "Shabnam", style: .callout, weight: .bold)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text(event)
                    .customFont(name: "Shabnam", style: .body, weight: .light)
            }
            
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct RectangularCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        } else {}
    }
}
