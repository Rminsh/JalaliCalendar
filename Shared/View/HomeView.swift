//
//  ContentView.swift
//  Shared
//
//  Created by armin on 1/28/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var selectedDate = Date()
    @State var events = [EventDetails]()
    
    @Environment(\.calendar) var calendar
    @Environment(\.scenePhase) var scenePhase
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    private var dayWeekFa: String {
        JalaliHelper.DayWeekFa.string(from: selectedDate)
    }
    
    private var yearFa: String {
        JalaliHelper.YearFa.string(from: selectedDate)
    }
    
    private var monthFa: String {
        JalaliHelper.MonthFa.string(from: selectedDate)
    }
    
    private var dayFa: String {
        JalaliHelper.DayFa.string(from: selectedDate)
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            content
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    var content: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 3) {
                // MARK: - Today contents
                VStack(alignment: .leading, spacing: 3) {
                    Text(dayWeekFa)
                        .customFont(style: .largeTitle, weight: .bold)
                        .foregroundColor(Color("TextColor"))
                    
                    Text("\(yearFa) \(monthFa) \(dayFa)")
                        .customFont(style: .title1, weight: .bold)
                        .foregroundColor(Color("AccentColor"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)
                
                // MARK: - Calendar progress
                HStack(alignment: .center, spacing: 50) {
                    if #available(iOS 16.0, macOS 13.0, *) {
                        Gauge(value: selectedDate.daysPassedInYear()) {
                            Text("سال")
                                .customFont(style: .callout, weight: .light)
                                .foregroundColor(Color("TextColor"))
                        } currentValueLabel: {
                            Text("\(String(format: "%.0f%%", selectedDate.daysPassedInYear() * 100))")
                        }
                        .tint(Color("AccentColor"))
                        .gaugeStyle(.accessoryLinearCapacity)
                        
                        Gauge(value: selectedDate.daysPassedInMonth()) {
                            Text("ماه")
                                .customFont(style: .callout, weight: .light)
                                .foregroundColor(Color("TextColor"))
                        } currentValueLabel: {
                            Text("\(String(format: "%.0f%%", selectedDate.daysPassedInMonth() * 100))")
                        }
                        .tint(Color("AccentColor"))
                        .gaugeStyle(.accessoryLinearCapacity)
                    }
                }
                .frame(
                    maxWidth: horizontalSizeClass == .compact ? .infinity : 300,
                    alignment: .center
                )
                .padding(.all, 25)
                
                // MARK: - Calendar Month View
                VStack {
                    HStack {
                        ForEach(["ش","ی","د","س","چ","پ","ج"], id: \.self) { day in
                            Text(day)
                                .customFont(style: .callout)
                                .frame(minWidth: 37)
                        }
                    }
                    
                    MonthView(month: selectedDate, showHeader: false) { date in
                        Text("30")
                            .hidden()
                            .padding(8)
                            .background(
                                date.checkIsToday(date: Date()) ?
                                Color("AccentColor"):
                                Color("DayTextBackground")
                            )
                            .clipShape(Circle())
                            .padding(.vertical, 4)
                            .overlay(
                                Text(JalaliHelper.DayFa.string(from: date))
                                    .customFont(style: .callout)
                                    .foregroundColor(
                                        date.checkIsToday(date: Date()) ?
                                        Color.white:
                                        Color("BackgroundColor")
                                    )
                            )
                            .overlay(
                                Circle().stroke(
                                    Color.accentColor,
                                    lineWidth: date.checkIsToday(date: selectedDate) ? 4 : 0
                                )
                            )
                            .animation(.easeIn, value: selectedDate)
                            .onTapGesture {
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                withAnimation(.interactiveSpring()) {
                                    selectedDate = date
                                    getEvents()
                                }
                            }
                    }
                    .padding()
                }

                // MARK: - EventView
                Text(!events.isEmpty ? "مناسبت‌های این روز" : "")
                    .font(.custom("Shabnam", size: 14))
                    .foregroundColor(Color("TextColor"))
                    .multilineTextAlignment(.trailing)
                    .animation(.interactiveSpring(), value: selectedDate)
                
                LazyVStack(alignment: .center) {
                    ForEach(events, id: \.self) { item in
                        Text(item.title)
                            .font(.custom("Shabnam-Light", size: 14))
                            .foregroundColor(Color("TextColor"))
                            .multilineTextAlignment(.leading)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("BackgroundColor"))
                                    .shadow(
                                        color: Color.black.opacity(0.2),
                                        radius: 10,
                                        x: 10,
                                        y: 10
                                    )
                                    .shadow(
                                        color: Color("BackgroundColorAlt").opacity(0.7),
                                        radius: 10,
                                        x: -5,
                                        y: -5
                                    )
                            )
                            .padding(.bottom, 12)
                    }
                }
                .padding(.all, 25)
                .animation(.interactiveSpring(), value: selectedDate)
            }
            .padding(.vertical)
        }
        .onChange(of: scenePhase) { _ in
            selectedDate = Date()
            getEvents()
        }
    }
    
    func getEvents() {
        EventService.shared.read { (result) in
            switch result {
            case .success:
                do {
                    events.removeAll()
                    let eventsData = try result.get()
                    for item in eventsData {
                        if item.day == Int(JalaliHelper.DayEn.string(from: selectedDate)) && item.month == Int(JalaliHelper.MonthEn.string(from: selectedDate)) {
                            events.append(item)
                        }
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.calendar, .persianCalendar)
            .background(Color("BackgroundColor"))
//            .preferredColorScheme(.dark)
    }
}
