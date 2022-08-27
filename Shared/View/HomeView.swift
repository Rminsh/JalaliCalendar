//
//  ContentView.swift
//  Shared
//
//  Created by armin on 1/28/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var currentDate = Date()
    @State var events = [EventDetails]()
    @State var showEventTitle = false
    
    @Environment(\.calendar) var calendar
    @Environment(\.scenePhase) var scenePhase
    
    private var month: DateInterval {
        calendar.dateInterval(of: .month, for: currentDate)!
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
                    Text("\(JalaliHelper.DayWeekFa.string(from: currentDate))")
                        .customFont(name: "Shabnam", style: .largeTitle, weight: .bold)
                        .foregroundColor(Color("TextColor"))
                    
                    Text("\(JalaliHelper.YearFa.string(from: currentDate)) \(JalaliHelper.MonthFa.string(from: currentDate)) \(JalaliHelper.DayFa.string(from: currentDate))")
                        .customFont(name: "Shabnam", style: .title1, weight: .bold)
                        .foregroundColor(Color("AccentColor"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)
                
                // MARK: - Calendar progress
                HStack(alignment: .center, spacing: 50) {
                    if #available(iOS 16.0, *) {
                        Gauge(value: currentDate.daysPassedInYear()) {
                            Text("سال")
                                .customFont(name: "Shabnam-Light", style: .callout, weight: .light)
                                .foregroundColor(Color("TextColor"))
                        } currentValueLabel: {
                            Text("\(String(format: "%.0f%%", currentDate.daysPassedInYear() * 100))")
                        }
                        .tint(Color("AccentColor"))
                        .gaugeStyle(.accessoryLinearCapacity)
                        
                        Gauge(value: currentDate.daysPassedInMonth()) {
                            Text("ماه")
                                .customFont(name: "Shabnam-Light", style: .callout, weight: .light)
                                .foregroundColor(Color("TextColor"))
                        } currentValueLabel: {
                            Text("\(String(format: "%.0f%%", currentDate.daysPassedInMonth() * 100))")
                        }
                        .tint(Color("AccentColor"))
                        .gaugeStyle(.accessoryLinearCapacity)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.all, 25)
                
                // MARK: - Calendar Month View
                VStack {
                    HStack {
                        ForEach(["ش","ی","د","س","چ","پ","ج"], id: \.self) { day in
                            Text(day)
                                .font(.custom("Shabnam", size: 14))
                                .frame(minWidth: 37)
                        }
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                    
                    MonthView(month: currentDate, showHeader: false) { date in
                        Text("30")
                            .hidden()
                            .padding(8)
                            .background(date.checkIsToday(date: currentDate) ? Color("AccentColor"): Color("DayTextBackground"))
                            .clipShape(Circle())
                            .padding(.vertical, 4)
                            .overlay(
                                Text(JalaliHelper.DayFa.string(from: date))
                                    .font(.custom("Shabnam", size: 14))
                                    .foregroundColor(date.checkIsToday(date: currentDate) ? Color.white: Color("BackgroundColor"))
                            )
                    }
                    .padding()
                }

                // MARK: - EventView
                Text(showEventTitle ? "مناسبت‌های امروز" : "")
                    .font(.custom("Shabnam", size: 14))
                    .foregroundColor(Color("TextColor"))
                    .multilineTextAlignment(.trailing)
                
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
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color("BackgroundColorAlt").opacity(0.7), radius: 10, x: -5, y: -5)
                            )
                            .padding(.bottom, 12)
                            .task {
                                showEventTitle = true
                            }
                    }
                }
                .padding(.all, 25)
            }
            .padding(.vertical)
        }
        .onChange(of: scenePhase) { _ in
            currentDate = Date()
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
                        if item.day == Int(JalaliHelper.DayEn.string(from: currentDate)) && item.month == Int(JalaliHelper.MonthEn.string(from: currentDate)) {
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
            .preferredColorScheme(.dark)
    }
}
