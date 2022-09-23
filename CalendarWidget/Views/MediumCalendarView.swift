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
            VStack(spacing: 4) {
                // MARK: - Calendar Header
                /// ⚠️ TODO : Merge this header to Calendar's MonthView
                HStack {
                    ForEach(["ش","ی","د","س","چ","پ","ج"], id: \.self) { day in
                        Text("30")
                            .hidden()
                            .padding(10)
                            .clipShape(Circle())
                            .padding(.vertical, 2)
                            .overlay(
                                Text(day)
                                    .customFont(name: "Shabnam", style: .caption2)
                            )
                            .frame(minWidth: 0, maxHeight: 15)
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
                
                // MARK: - Calendar View
                MonthView(month: date, showHeader: false) { dateItem in
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
