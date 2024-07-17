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
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var nextMonth: Date {
        calendar.date(byAdding: .month, value: 1, to: date) ?? date
    }
    
    var body: some View {
        Group {
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                content
                    .containerBackground(.widgetBackground, for: .widget)
            } else {
                content
                    .padding()
                    .background(.widgetBackground)
            }
        }
    }
    
    var content: some View {
        HStack(alignment: .top, spacing: 10) {
            createMonth(month: date)
            createMonth(month: nextMonth)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
    }
    
    @ViewBuilder
    func createMonth(month: Date) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            // MARK: - Calendar Month Title
            Text(month, format: formatter.month())
                #if os(macOS)
                .font(.customFont(style: .headline, weight: .bold))
                #else
                .font(.customFont(style: .caption1, weight: .bold))
                #endif
                .foregroundStyle(.accent)
                .dynamicTypeSize(.xSmall ... .xLarge)
                .id(date.formatted(.dateTime.month()))
                .transition(.push(from: .top))
                .animation(.smooth, value: date)
            
            // MARK: - Calendar Month days
            MonthView(month: month) { weekday in
                Text(weekday)
                    #if os(macOS)
                    .font(.customFont(style: .callout))
                    #else
                    .font(.customFont(style: .caption2))
                    #endif
                    .foregroundStyle(weekday == "ج" ? .secondary : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 2)
            } content: { dateItem in
                Text(dateItem, format: formatter.day())
                    #if os(macOS)
                    .font(.customFont(style: .callout))
                    #else
                    .font(.customFont(style: .caption2))
                    #endif
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 2)
                    .foregroundStyle(
                        dateItem.checkIsToday(date: date) ?
                        .white :
                        dateItem.isSaturday() ? .secondary : .primary
                    )
                    .background {
                        Circle()
                            .fill(
                                dateItem.checkIsToday(date: date) ?
                                Color("AccentColor") :
                                Color.clear
                            )
                    }
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview(as: .systemMedium) {
    MonthWidget()
} timeline: {
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 6))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 5))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 4))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 3))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 2))
    SimpleEntry(date: .now.addingTimeInterval(-24 * 60 * 60 * 30 * 1))
    SimpleEntry(date: .now)
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 1))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 2))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 3))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 4))
    SimpleEntry(date: .now.addingTimeInterval(24 * 60 * 60 * 30 * 5))
}
