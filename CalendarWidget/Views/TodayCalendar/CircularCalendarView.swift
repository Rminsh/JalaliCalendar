//
//  CircularCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/25/22.
//

import SwiftUI
import WidgetKit

struct CircularCalendarView: View {
    
    var month: String
    var dayNumber: String
    
    var body: some View {
        ZStack {
            if #available(iOSApplicationExtension 16.0, *) {
                AccessoryWidgetBackground()
                VStack(spacing: 0) {
                    Text(dayNumber)
                        .customFont(
                            name: "Shabnam",
                            style: .title1,
                            weight: .bold
                        )
                    
                    Text(month)
                        .customFont(
                            name: "Shabnam",
                            style: .footnote,
                            weight: .medium
                        )
                        .scaleEffect(0.8)
                        .padding(.top, -8)
                        .widgetAccentable()
                }
                .padding(.bottom, 4)
            }
        }
    }
}

struct CircularCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        } else {}
    }
}
