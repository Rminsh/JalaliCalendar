//
//  MediumCalendarView.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import SwiftUI
import WidgetKit

struct MediumCalendarView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    
    var body: some View {
        HStack(spacing: 10) {
            // MARK: - Today View
            SmallCalendarView(date: date)
            
            // MARK: - Calendar Month View
            MonthView(
                month: date,
                showHeader: false
            ) { weekday in
                Text("30")
                    .hidden()
                    .padding(8)
                    .clipShape(Circle())
                    .padding(.vertical, 2)
                    .overlay(
                        Text(weekday)
                            .customFont(name: "Shabnam", style: .caption2)
                    )
                    .frame(minWidth: 0, maxHeight: 15)
                    .padding(.bottom, 2)
            } content: { dateItem in
                Text("30")
                    .hidden()
                    .padding(8)
                    .background(dateItem.checkIsToday(date: date) ? Color("AccentColor"): .clear)
                    .clipShape(Circle())
                    .padding(.vertical, 2)
                    .overlay(
                        Text(JalaliHelper.DayFa.string(from: dateItem))
                            .customFont(name: "Shabnam", style: .caption2)
                            .foregroundColor(dateItem.checkIsToday(date: date) ? Color.white: Color("TextColor"))
                    )
                    .frame(minWidth: 0, maxHeight: 15)
            }
            .environment(\.layoutDirection, .rightToLeft)
            .environment(\.calendar, .persianCalendar)
        }
        .padding(.all)
    }
}

struct MediumCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
