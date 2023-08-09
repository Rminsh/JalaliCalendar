//
//  HomeView.swift
//  JalaliCalendar
//
//  Created by Armin on 6/8/23.
//

import SwiftUI

struct HomeView: View {
    
    @State var selectedDate = Date()
    @State var events = CalendarEvents.persianCalendarEvents
    @State private var showReset: Bool = false
    
    @Environment(\.calendar) var calendar
    @Environment(\.scenePhase) var scenePhase
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var formatter: Date.FormatStyle {
        Date.FormatStyle(calendar: calendar)
    }
    
    var calendarComponents: DateComponents {
        return Calendar.persianCalendar.dateComponents(
            [.day, .year, .month],
            from: selectedDate
        )
    }
    
    var currentDateEvents: [EventDetails] {
        return events.filter { item in
            item.day == calendarComponents.day &&
               item.month == calendarComponents.month
        }
    }
    
    var body: some View {
        #if os(iOS)
        NavigationStack {
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
                            .customFont(style: .title1)
                            .labelStyle(.iconOnly)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.borderless)
                    
                    // MARK: - Today contents
                    VStack(alignment: .center, spacing: 3) {
                        Text(selectedDate, format: formatter.weekday(.wide))
                            .customFont(style: .largeTitle, weight: .bold)
                            .foregroundColor(Color("TextColor"))
                        
                        Text(selectedDate, format: formatter.year().month().day())
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
                            .customFont(style: .title1)
                            .labelStyle(.iconOnly)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.borderless)
                }
                
                // MARK: - Progresses
                HStack(alignment: .center, spacing: 50) {
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
                MonthView(month: selectedDate) { weekday in
                    Text(weekday)
                        .customFont(style: .callout)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 12)
                } content: { date in
                    Text(date, format: formatter.day())
                        .customFont(style: .callout)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .dynamicTypeSize(.xSmall ... .medium)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(
                            date.checkIsToday(date: Date()) ?
                            Color.white:
                            Color("BackgroundColor")
                        )
                        .padding(8)
                        .background(
                            date.checkIsToday(date: Date()) ?
                            Color("AccentColor"):
                            Color("DayTextBackground").opacity(date.isSaturday() ? 0.75 : 1)
                        )
                        .clipShape(Circle())
                        .padding(.vertical, 4)
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
                .frame(maxWidth: 300)

                // MARK: - EventView
                Text(!currentDateEvents.isEmpty ? "مناسبت‌های این روز" : "")
                    .customFont(style: .body)
                    .foregroundColor(Color("TextColor"))
                    .multilineTextAlignment(.trailing)
                    .animation(.interactiveSpring(), value: selectedDate)
                
                LazyVStack(alignment: .center) {
                    ForEach(currentDateEvents, id: \.self) { item in
                        Text(item.title)
                            .customFont(style: .body, weight: .light)
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
                        .customFont(style: .body)
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
        }
    }
    
    func moveDate(to date: Date, showReset: Bool = true) {
        #if os(iOS)
        let hapticGenerator = UIImpactFeedbackGenerator(style: .soft)
        hapticGenerator.impactOccurred()
        #endif
        withAnimation(.interactiveSpring()) {
            selectedDate = date
            self.showReset = showReset
        }
    }
}

#Preview {
    HomeView()
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.calendar, Calendar(identifier: .persian))
}
