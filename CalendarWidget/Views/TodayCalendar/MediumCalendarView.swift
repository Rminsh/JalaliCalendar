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
                Text(weekday)
                    .customFont(style: .caption2)
                    .foregroundStyle(.secondary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 2)
            } content: { dateItem in
                Text(JalaliHelper.DayFa.string(from: dateItem))
                    .customFont(style: .caption1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.56)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(
                        dateItem.checkIsToday(date: date) ?
                        Color.white:
                        Color("TextColor").opacity(dateItem.isSaturday() ? 0.65 : 1)
                    )
                    .background(
                        Circle()
                            .fill(
                                dateItem.checkIsToday(date: date) ?
                                Color("AccentColor"):
                                    Color.clear
                            )
                            .padding(-2)
                    )
            }
            .padding(.vertical)
            .environment(\.layoutDirection, .rightToLeft)
            .environment(\.calendar, .persianCalendar)
        }
        .padding(.horizontal)
    }
}

struct MediumCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
