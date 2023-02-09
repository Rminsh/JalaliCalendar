//
//  SmallMonthView.swift
//  JalaliCalendar
//
//  Created by Armin on 2/9/23.
//

import SwiftUI
import WidgetKit

struct SmallMonthView: View {
    
    var date: Date
    
    @Environment(\.calendar) var calendar
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // MARK: - Calendar Month View
            MonthView(
                month: date,
                showHeader: true
            ) { weekday in
                Text(weekday)
                    .customFont(style: .caption2)
                    .foregroundStyle(.secondary)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 2)
            } content: { dateItem in
                Text(JalaliHelper.DayFa.string(from: dateItem))
                    .customFont(style: .caption2)
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
        .fixedSize()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
    }
}

struct SmallMonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
