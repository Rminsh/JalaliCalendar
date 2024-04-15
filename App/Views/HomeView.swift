//
//  HomeView.swift
//  JalaliCalendar
//
//  Created by Armin on 6/8/23.
//

import SwiftUI

struct HomeView {
    @State var selectedDate: Date = Date()
    @State var events: [EventDetails] = CalendarEvents.persianCalendarEvents
    @State private var showReset: Bool = false
    @State private var showDateConverter: Bool = false
    
    @Environment(\.scenePhase) var scenePhase
    #if canImport(UIKit)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var persianDate: Date.FormatStyle {
        Date.FormatStyle(calendar: .persianCalendar)
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
    
extension HomeView: View {
    
    var body: some View {
        #if canImport(UIKit)
        NavigationStack {
            ZStack {
                #if os(iOS)
                RadialGradient(
                    colors: [.accent, .red, .indigo],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 519
                )
                .blur(radius: 400)
                .edgesIgnoringSafeArea(.all)
                #endif
                
                content
            }
        }
        .navigationViewStyle(.stack)
        .environment(\.layoutDirection, .rightToLeft)
        #elseif canImport(AppKit)
        ZStack {
            VisualEffectBlur(
                material: .popover,
                blendingMode: .behindWindow,
                state: .active
            )
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
                /// Top Section of the calendar
                HStack {
                    backMonthNavigation
                    
                    /// Today contents
                    VStack(alignment: .center, spacing: 3) {
                        currentWeekdayText
                        currentDateText
                    }
                    .frame(minWidth: 168)
                    .padding(.horizontal, 25)
                    
                    nextMonthNavigation
                }
                
                /// Progresses
                HStack(alignment: .center, spacing: 50) {
                    yearProgress
                    monthProgress
                }
                #if os(iOS)
                .frame(
                    maxWidth: horizontalSizeClass == .compact ? .infinity : 300,
                    alignment: .center
                )
                #elseif os(macOS) || os(visionOS)
                .frame(maxWidth: 450, alignment: .center)
                #endif
                .padding(.all, 25)
                
                /// Month Calendar view
                calendarView
                    .frame(maxWidth: 325)

                /// EventView
                eventsList
                    .padding(.top, 25)
            }
            .padding(.vertical)
        }
        #if os(iOS)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        #endif
        .toolbar {
            ToolbarItem(placement: .navigation) {
                resetDate
            }
            #if !os(visionOS)
            ToolbarItem(placement: .automatic) {
                convertDateButton
            }
            #endif
        }
        #if os(visionOS)
        .onChange(of: scenePhase) {
            selectedDate = Date()
        }
        #else
        .onChange(of: scenePhase) { _ in
            selectedDate = Date()
        }
        #endif
        .sheet(isPresented: $showDateConverter) {
            DateConverterView()
        }
    }
    
    // MARK: - Current date's Weekday
    var currentWeekdayText: some View {
        Text(selectedDate, format: persianDate.weekday(.wide))
            .customFont(style: .largeTitle, weight: .bold)
            .foregroundStyle(.primary)
            .environment(\.locale, .init(identifier: "fa"))
    }
    
    // MARK: - Current date's Full date
    var currentDateText: some View {
        VStack {
            Text(selectedDate, format: persianDate.year().month().day())
                .customFont(style: .title1, weight: .bold)
                .foregroundStyle(.accent)
            
            Text(selectedDate, format: .dateTime.year().month().day())
                .customFont(style: .title3, weight: .light)
                .foregroundStyle(.accent.opacity(0.85))
        }
        .environment(\.locale, .init(identifier: "fa"))
    }
    
    // MARK: - Previous month
    var backMonthNavigation: some View {
        Button {
            moveDate(to: selectedDate.adding(.month, value: -1))
        } label: {
            Label("ماه قبل", systemImage: "chevron.compact.right")
                .customFont(style: .title1)
                .labelStyle(.iconOnly)
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.tertiary)
    }
    
    // MARK: - Next month
    var nextMonthNavigation: some View {
        Button {
            moveDate(to: selectedDate.adding(.month, value: 1))
        } label: {
            Label("ماه بعد", systemImage: "chevron.compact.left")
                .customFont(style: .title1)
                .labelStyle(.iconOnly)
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.tertiary)
    }
    
    // MARK: - Year Progress
    var yearProgress: some View {
        Gauge(value: selectedDate.daysPassedInYear()) {
            Text("سال")
                .customFont(style: .callout, weight: .light)
                .foregroundStyle(.text)
        } currentValueLabel: {
            Text("\(String(format: "%.0f%%", selectedDate.daysPassedInYear() * 100))")
        }
        .tint(Color.accent)
        .gaugeStyle(.accessoryLinearCapacity)
    }
    
    // MARK: - Month Progress
    var monthProgress: some View {
        Gauge(value: selectedDate.daysPassedInMonth()) {
            Text("ماه")
                .customFont(style: .callout, weight: .light)
                .foregroundStyle(.text)
        } currentValueLabel: {
            Text("\(String(format: "%.0f%%", selectedDate.daysPassedInMonth() * 100))")
        }
        .tint(Color.accent)
        .gaugeStyle(.accessoryLinearCapacity)
    }
    
    // MARK: - Calendar Month View
    var calendarView: some View {
        MonthView(month: selectedDate) { weekday in
            Text(weekday)
                .customFont(style: .callout)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 12)
                .environment(\.locale, .init(identifier: "fa"))
        } content: { date in
            let isToday = date.checkIsToday(date: Date())
            
            VStack {
                Text(date, format: persianDate.day())
                    .customFont(style: .headline)
                    .dynamicTypeSize(.xSmall ... .medium)
                    .environment(\.locale, .init(identifier: "fa"))
                
                Text(date, format: .dateTime.day())
                    .customFont(style: .caption2)
                    .dynamicTypeSize(.xSmall)
                    .environment(\.locale, .init(identifier: "en_US"))
            }
            .foregroundStyle(isToday ? .white : date.checkIsToday(date: selectedDate) ? .focusedText : .primary)
            .lineLimit(1)
            .minimumScaleFactor(0.2)
            .frame(maxWidth: .infinity)
            .padding(5)
            .background(isToday ? .accent : date.checkIsToday(date: selectedDate) ? .primary : .clear)
            #if os(visionOS)
            .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 8))
            #else
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white.opacity(0.3), lineWidth: 0.8)
            }
            #endif
            .padding(.vertical, 2)
            .padding(.horizontal, 2)
            .onTapGesture {
                moveDate(to: date)
            }
        }
        .environment(\.calendar, .persianCalendar)
    }
    
    // MARK: - Events items
    var eventsList: some View {
        VStack {
            Text(!currentDateEvents.isEmpty ? "مناسبت‌های این روز" : "")
                .customFont(style: .body)
                .foregroundStyle(.text)
                .multilineTextAlignment(.trailing)
                .animation(.interactiveSpring(), value: selectedDate)
            
            LazyVStack(alignment: .center) {
                ForEach(currentDateEvents, id: \.self) { item in
                    Text(item.title)
                        .customFont(style: .body, weight: .light)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        #if os(iOS)
                        .background(.thinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(.white.opacity(0.3), lineWidth: 0.8)
                        }
                        #elseif os(visionOS)
                        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        #elseif os(macOS)
                        .background {
                            VisualEffectBlur(
                                material: .fullScreenUI,
                                blendingMode: .withinWindow,
                                state: .active
                            )
                        }
                        #endif
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 2)
                        .padding(.bottom, 12)
                        #if os(iOS)
                        .frame(
                            maxWidth: horizontalSizeClass == .compact ? .infinity : 300,
                            alignment: .center
                        )
                        #elseif os(macOS) || os(visionOS)
                        .frame(maxWidth: 450, alignment: .center)
                        #endif
                }
            }
            .padding(.horizontal, 25)
            .animation(.interactiveSpring(), value: selectedDate)
        }
    }
    
    // MARK: - Reset date button
    var resetDate: some View {
        Button(action: {moveDate(to: Date(), showReset: false)}) {
            Label("برو به امروز", systemImage: "arrow.uturn.left")
                .customFont(style: .body)
        }
        .disabled(!showReset)
    }
    
    // MARK: - Date converter button
    var convertDateButton: some View {
        Button(action: {showDateConverter.toggle()}) {
            Label("تبدیل تاریخ", systemImage: "clock.arrow.2.circlepath")
                .customFont(style: .body)
        }
    }
}

#Preview {
    HomeView()
}
