//
//  ContentView.swift
//  Shared
//
//  Created by armin on 1/28/21.
//

import SwiftUI

struct HomeView: View {
    
    let currentDate = Date()
    @State var events = [EventDetails]()
    @State var showEventTitle = false
    
    @Environment(\.calendar) var calendar
    
    private var month: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 3) {
                
                // MARK: - Today contents
                VStack(alignment: .center, spacing: 3) {
                    Text(JalaliHelper.DayFa.string(from: currentDate))
                        .font(.custom("Shabnam-Bold", size: 84))
                        .foregroundColor(Color("TextColor"))
                    Text("\(JalaliHelper.DayWeekFa.string(from: currentDate))")
                        .font(.custom("Shabnam-Bold", size: 28))
                        .foregroundColor(Color("AccentColor"))
                        .padding(.top, -30)
                    
                    Text("\(JalaliHelper.YearFa.string(from: currentDate)) \(JalaliHelper.MonthFa.string(from: currentDate))")
                        .font(.custom("Shabnam-Bold", size: 28))
                        .foregroundColor(Color("AccentColor"))
                }
                .padding(.horizontal)
                
                // MARK: - Calendar progress
                HStack(alignment: .center, spacing: 50) {
                    GaugeView(
                        progress: currentDate.daysPassedInYear(),
                        title: "سال")
                    GaugeView(
                        progress: currentDate.daysPassedInMonth(),
                        title: "ماه")
                }
                .padding()
                
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
                    .environment(\.layoutDirection, .rightToLeft)
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
                            .multilineTextAlignment(.trailing)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("BackgroundColor"))
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color("BackgroundColorAlt").opacity(0.7), radius: 10, x: -5, y: -5)
                            )
                            .padding(.bottom, 12)
                            .onAppear(perform: {showEventTitle = true})
                            
                    }
                }
                .padding(.all, 25)
            }
            .padding(.vertical)
            .onAppear(perform: getEvents)
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
            .environment(\.calendar, {
                var calendar = Calendar(identifier: .persian)
                calendar.locale = Locale(identifier: "fa")
                return calendar
            }())
            .background(Color("BackgroundColor"))
            .preferredColorScheme(.dark)
    }
}
