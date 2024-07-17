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
                #if os(macOS)
                .font(.customFont(
                    style: showsWidgetBackground ? .headline : .body,
                    weight: .bold
                ))
                #else
                .font(.customFont(
                    style: showsWidgetBackground ? .caption1 : .body,
                    weight: .bold
                ))
                #endif
                .foregroundStyle(.accent)
                .widgetAccentable()
                .dynamicTypeSize(.xSmall ... .xLarge)
                .id(date.formatted(.dateTime.month()))
                .transition(.push(from: .top))
                .animation(.smooth, value: date)
            
            // MARK: - Calendar Month days
            MonthView(month: date) { weekday in
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
                let isToday: Bool = dateItem.checkIsToday(date: date)
                textDate(dateItem)
                    .foregroundStyle(isToday ? .clear : dateItem.isSaturday() ? .secondary : .primary)
                    .background {
                        Circle()
                            .fill(isToday ? Color.accent: Color.clear)
                            .widgetAccentable()
                            .reverseMask {
                                textDate(dateItem)
                            }
                            .padding(-2)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.calendar, .persianCalendar)
    }
    
    @ViewBuilder
    func textDate(_ date: Date) -> some View {
        Text(date, format: formatter.day())
            #if os(macOS)
            .font(.customFont(style: .callout))
            #else
            .font(.customFont(style: .caption2))
            #endif
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
