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
                    .font(.custom("Shabnam-Bold", size: 38))
                    .foregroundColor(Color("TextColor"))
                // MARK: - Month name
                Text(month)
                    .font(.custom("Shabnam-Bold", size: 17))
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top, -20)
                // MARK: - Today's event
                Text(event)
                    .lineLimit(1)
                    .font(.custom("Shabnam-Light", size: 10))
                    .foregroundColor(Color("TextColor"))
            }
            .padding(.horizontal)
            
            /// ⏰ Note: These ProgressBars will be used for due time
            /// in addition to the current mode in the future.
            HStack(alignment: .center) {
                // MARK: - Year's Progress
                ProgressBar(
                    progress: firstProgress,
                    title: firstTitle)
                
                Spacer()
                
                // MARK: - Month's Progress
                ProgressBar(
                    progress: secondProgress,
                    title: secondTitle)
            }
            .padding(.vertical, 5)
            
        }
    }
}

struct SmallCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        SmallCalendarView(
            day: "۱۸",
            month: "اردیبهشت",
            event: "روز ملی شدن صنعت نفت ",
            firstProgress: 0.13,
            firstTitle: "سال",
            secondProgress: 0.58,
            secondTitle: "ماه")
            .padding(.vertical)
            .background(Color("WidgetBackground"))
            .colorScheme(.dark)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
