//
//  SmallCalendarView.swift
//  CalendarWidgetExtension
//
//  Created by armin on 2/2/21.
//

import SwiftUI
import WidgetKit

struct SmallCalendarView: View {
    
    var day: String
    var month: String
    var event: String
    var firstProgress: Float
    var firstTitle: String
    var secondProgress: Float
    var secondTitle: String
    
    var body: some View {
        
        VStack(alignment: .trailing, spacing: 3) {
            VStack(alignment: .trailing) {
                // MARK: - Day number
                Text(day)
                    .customFont(name: "Shabnam", style: .largeTitle, weight: .bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.bottom, -24)
                // MARK: - Month name
                Text(month)
                    .customFont(name: "Shabnam", style: .title3, weight: .bold)
                    .foregroundColor(Color("AccentColor"))
                // MARK: - Today's event
                Text(event)
                    .customFont(name: "Shabnam", style: .caption1, weight: .light)
                    .lineLimit(1)
                    .multilineTextAlignment(.trailing)
                    .minimumScaleFactor(0.9)
                    .foregroundColor(Color("TextColor"))
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            /// ⏰ Note: These Gauges will be used for due time
            /// in addition to the current mode in the future.
            HStack(alignment: .center) {
                // MARK: - Year's Progress
                GaugeView(
                    progress: firstProgress,
                    title: firstTitle
                )
                .scaleEffect(0.8)
                
                Spacer()
                
                // MARK: - Month's Progress
                GaugeView(
                    progress: secondProgress,
                    title: secondTitle
                )
                .scaleEffect(0.8)
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 8)
        }
    }
}

struct SmallCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: WidgetEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
