//
//  RectangularMonthView.swift
//  CalendarWidgetExtension (iOS)
//
//  Created by Armin on 2/10/23.
//

import SwiftUI
import WidgetKit

struct RectangularMonthView: View {
    
    var today: Date
    
    var body: some View {
        MonthView(
            month: today,
            showHeader: false,
            onlySummary: true
        ) { weekday in
            Text(weekday)
                .customFont(style: .caption2, weight: .bold)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .dynamicTypeSize(.xSmall)
                .frame(maxWidth: .infinity)
        } content: { dateItem in
            Text(JalaliHelper.DayFa.string(from: dateItem))
                .customFont(style: .footnote, weight: .bold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .dynamicTypeSize(.xSmall)
                .frame(maxWidth: .infinity)
                .foregroundColor(
                    dateItem.checkIsToday(date: today) ?
                    Color.white:
                    Color("TextColor").opacity(dateItem.isSaturday() ? 0.65 : 1)
                )
                .background {
                    if dateItem.checkIsToday(date: today) {
                        if #available(iOSApplicationExtension 16.0, *) {
                            AccessoryWidgetBackground()
                                .padding(.all, -2)
                                .clipShape(Circle())
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                        
                }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
    }
}

struct RectangularMonthView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            MonthWidgetEntryView(entry: WidgetEntry(date: Date().addingTimeInterval(60 * 60 * 24 * 0)))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        } else {}
    }
}
