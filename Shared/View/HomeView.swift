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
    @State private var showReset: Bool = false
    
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
        #if os(iOS)
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                content
            }
        }
        .navigationViewStyle(.stack)
        .environment(\.layoutDirection, .rightToLeft)
        #else
        ZStack {
            VisualEffectBlur(material: .popover, blendingMode: .behindWindow)
                .edgesIgnoringSafeArea(.all)
            
            content
                .shadow(color: .accentColor.opacity(0.15), radius: 2)
        }
        .environment(\.layoutDirection, .rightToLeft)
        #endif
    }
    
    var content: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 3) {
                HStack {
                    // MARK: - Previous month
                    Button(action: {
                        moveDate(to: selectedDate.adding(.month, value: -1))
                    }) {
                        Label("ماه قبل", systemImage: "chevron.compact.right")
                            .font(.title)
                            .labelStyle(.iconOnly)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.borderless)
                    
                    // MARK: - Today contents
                    VStack(alignment: .center, spacing: 3) {
                        Text(dayWeekFa)
                            .customFont(style: .largeTitle, weight: .bold)
                            .foregroundColor(Color("TextColor"))
                        
                        Text("\(yearFa) \(monthFa) \(dayFa)")
                            .customFont(style: .title1, weight: .bold)
                            .foregroundColor(Color("AccentColor"))
                    }
                    .frame(minWidth: 168)
                    .padding(.horizontal, 25)
                    
                    // MARK: - Next month
                    Button(action: {
                        moveDate(to: selectedDate.adding(.month, value: 1))
                    }) {
                        Label("ماه بعد", systemImage: "chevron.compact.left")
                            .font(.title)
                            .labelStyle(.iconOnly)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.borderless)
                }
                
                // MARK: - Progresses
                HStack(alignment: .center, spacing: 50) {
                    if #available(iOS 16.0, macOS 13.0, *) {
                        // MARK: - Year Progress
                        Gauge(value: selectedDate.daysPassedInYear()) {
                            Text("سال")
                                .customFont(style: .callout, weight: .light)
                                .foregroundColor(Color("TextColor"))
                        } currentValueLabel: {
                            Text("\(String(format: "%.0f%%", selectedDate.daysPassedInYear() * 100))")
                        }
                        .tint(Color("AccentColor"))
                        .gaugeStyle(.accessoryLinearCapacity)
                        
                        // MARK: - Month Progress
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
                #if os(iOS)
                .frame(
                    maxWidth: horizontalSizeClass == .compact ? .infinity : 300,
                    alignment: .center
                )
                #elseif os(macOS)
                .frame(maxWidth: 450, alignment: .center)
                #endif
                .padding(.all, 25)
                
                // MARK: - Calendar Month View
                MonthView(
                    month: selectedDate,
                    showHeader: false
                ) { weekday in
                    Text("30")
                        .hidden()
                        .padding(8)
                        .clipShape(Circle())
                        .padding(.vertical, 4)
                        .overlay(
                            Text(weekday)
                                .customFont(style: .callout)
                        )
                } content: { date in
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
                            moveDate(to: date)
                        }
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
                            #if os(iOS)
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
                            #elseif os(macOS)
                            .background(VisualEffectBlur(material: .fullScreenUI, blendingMode: .withinWindow))
                            .cornerRadius(8)
                            .shadow(radius: 10, x: -5, y: -5)
                            #endif
                            .padding(.bottom, 12)
                    }
                }
                .padding(.all, 25)
                .animation(.interactiveSpring(), value: selectedDate)
            }
            .padding(.vertical)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {moveDate(to: Date(), showReset: false)}) {
                    Label("برو به امروز", systemImage: "arrow.uturn.left")
                }
                .disabled(!showReset)
                .opacity(showReset ? 1 : 0)
            }
        }
        #if os(iOS)
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
            }
            .background(Color("BackgroundColor"))
            .blur(radius: 5)
        }
        #endif
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
    
    func moveDate(to date: Date, showReset: Bool = true) {
        #if os(iOS)
        let hapticGenerator = UIImpactFeedbackGenerator(style: .soft)
        hapticGenerator.impactOccurred()
        #endif
        withAnimation(.interactiveSpring()) {
            selectedDate = date
            getEvents()
            self.showReset = showReset
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.calendar, .persianCalendar)
            .background(Color("BackgroundColor"))
    }
}
