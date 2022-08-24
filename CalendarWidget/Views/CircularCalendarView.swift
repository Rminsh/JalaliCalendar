//
//  CircularCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by Armin on 8/25/22.
//

import SwiftUI
import WidgetKit

struct CircularCalendarView: View {
    
    var day: String
    var dayNumber: String
    
    var body: some View {
        ZStack {
            if #available(iOSApplicationExtension 16.0, *) {
                AccessoryWidgetBackground()
                VStack(spacing: 0) {
                    Text(dayNumber)
                        .customFont(name: "Shabnam-bold", style: .title1, weight: .bold)
                    
                    Text(day)
                        .customFont(name: "Shabnam-light", style: .footnote, weight: .light)
                        .scaleEffect(0.8)
                        .padding(.top, -8)
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
        } else {
            // Fallback on earlier versions
        }
    }
}