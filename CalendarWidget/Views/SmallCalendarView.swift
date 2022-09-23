//
//  SmallCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by armin on 2/2/21.
//

import SwiftUI
import WidgetKit

struct SmallCalendarView: View {
    
    var date: Date
    
    var day: String {
        JalaliHelper.DayFa.string(from: date)
    }
    
    var month: String {
        JalaliHelper.MonthFa.string(from: date)
    }
    
    var event: String {
        EventService.shared.getEvent()
    }
    
    var firstProgress: Float {
        date.daysPassedInYear()
    }
    
    var secondProgress: Float {
        date.daysPassedInMonth()
    }
    
    var firstTitle: String = "سال"
    var secondTitle: String = "ماه"
    
    var body: some View {
        VStack(alignment: .trailing) {
            VStack(alignment: .trailing, spacing: 0) {
                // MARK: - Day number
                Text(day)
                    .customFont(name: "Shabnam", style: .largeTitle, weight: .bold)
                    .foregroundColor(Color("TextColor"))
                    #if os(iOS)
                    .padding(.vertical, -10)
                    #endif
                // MARK: - Month name
                Text(month)
                    .customFont(name: "Shabnam", style: .title3, weight: .bold)
                    .foregroundColor(Color("AccentColor"))
                // MARK: - Today's event
                Text(event)
                    .customFont(name: "Shabnam", style: .footnote, weight: .light)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                    .minimumScaleFactor(0.7)
                    .foregroundColor(Color("TextColor"))
            }
            .padding(.horizontal, 8)
            .frame(maxHeight: .infinity)
            
            HStack(alignment: .center) {
                // MARK: - Year's Progress
                GaugeView(
                    progress: firstProgress,
                    title: firstTitle
                )
                .scaleEffect(0.8)

                Spacer()

                // MARK: - Month's Progress
                GaugeView(
                    progress: secondProgress,
                    title: secondTitle
                )
                .scaleEffect(0.8)
            }
            .padding(.vertical, -6)
        }
        .padding(.vertical, 16)
    }
}

struct SmallCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
