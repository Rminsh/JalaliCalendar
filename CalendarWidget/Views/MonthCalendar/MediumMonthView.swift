//
//  MediumMonthView.swift
//  JalaliCalendar
//
//  Created by Armin on 2/9/23.
//

import SwiftUI
import WidgetKit

struct MediumMonthView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    
    var nextMonth: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            // MARK: - Current Month
            createMonth(month: date)
                .fixedSize()
            
            Spacer()
            
            createMonth(month: nextMonth)
                .fixedSize()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
    }
    
    @ViewBuilder
    func createMonth(month: Date) -> some View {
        MonthView(
            month: month,
            showHeader: true
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
    }
}

struct MediumMonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthWidgetEntryView(
            entry: WidgetEntry(
                date: Date().addingTimeInterval(60 * 60 * 24 * 30 * 0)
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
