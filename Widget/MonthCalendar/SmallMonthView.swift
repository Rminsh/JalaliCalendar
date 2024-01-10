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
    @Environment(\.showsWidgetContainerBackground) var showsWidgetBackground
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
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
        VStack(alignment: .leading, spacing: 5) {
            // MARK: - Calendar Month Title
            Text(date, format: formatter.month())
                .customFont(
                    style: showsWidgetBackground ? .caption1 : .body,
                    weight: .bold
                )
                .foregroundStyle(.accent)
                .dynamicTypeSize(.xSmall ... .xLarge)
                .id(date.formatted(.dateTime.month()))
                .transition(.push(from: .top))
                .animation(.smooth, value: date)
            
            // MARK: - Calendar Month days
            MonthView(month: date) { weekday in
                Text(weekday)
                    .customFont(style: .caption2)
                    .foregroundStyle(weekday == "ج" ? .secondary : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .dynamicTypeSize(.xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 2)
            } content: { dateItem in
                textDate(dateItem)
                    .foregroundStyle(
                        showsWidgetBackground ?
                        (dateItem.checkIsToday(date: date) ? .white : dateItem.isSaturday() ? .secondary : .primary) :
                        (dateItem.checkIsToday(date: date) ? .clear : dateItem.isSaturday() ? .secondary : .primary)
                    )
                    .background(
                        Circle()
                            .fill(
                                dateItem.checkIsToday(date: date) ?
                                Color.accent:
                                    Color.clear
                            )
                            .reverseMask {
                                if !showsWidgetBackground {
                                    textDate(dateItem)
                                }
                            }
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
    }
    
    @ViewBuilder
    func textDate(_ date: Date) -> some View {
        Text(date, format: formatter.day())
            .customFont(style: .caption2)
            .lineLimit(1)
            .minimumScaleFactor(0.9)
            .dynamicTypeSize(.xSmall)
            .frame(maxWidth: .infinity)
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview(as: .systemSmall) {
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
