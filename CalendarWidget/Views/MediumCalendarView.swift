//
//  MediumCalendarView.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import SwiftUI
import WidgetKit

struct MediumCalendarView: View {
    
    var day: String
    var month: String
    var event: String
    var firstProgress: Float
    var firstTitle: String
    var secondProgress: Float
    var secondTitle: String
    
    @Environment(\.calendar) var calendar
    
    let currentDate = Date()
    
    var body: some View {
        HStack(spacing: 4) {
            // MARK: - Today View
            SmallCalendarView(
                day: day,
                month: month,
                event: event,
                firstProgress: firstProgress,
                firstTitle: firstTitle,
                secondProgress: secondProgress,
                secondTitle: secondTitle
            )
            
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
                            .frame(minWidth: 0, maxHeight: 20)
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
                
                // MARK: - Calendar View
                MonthView(month: currentDate, showHeader: false) { date in
                    Text("30")
                        .hidden()
                        .padding(10)
                        .background(date.checkIsToday(date: currentDate) ? Color("AccentColor"): .clear)
                        .clipShape(Circle())
                        .padding(.vertical, 2)
                        .overlay(
                            Text(JalaliHelper.DayFa.string(from: date))
                                .font(.custom("Shabnam", size: 12))
                                .foregroundColor(date.checkIsToday(date: currentDate) ? Color.white: Color("TextColor"))
                        )
                        .frame(minWidth: 0, maxHeight: 20)
                }
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.calendar, .persianCalendar)
            }
            
        }
    }
}

struct MediumCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
