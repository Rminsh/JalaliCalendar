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
        #if os(iOS)
        NavigationStack {
            ZStack {
                RadialGradient(
                    colors: [.accent, .red, .indigo],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 519
                )
                .blur(radius: 400)
                .edgesIgnoringSafeArea(.all)
                
                content
            }
        }
        .navigationViewStyle(.stack)
        .environment(\.layoutDirection, .rightToLeft)
        #else
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
                HStack {
                    // MARK: - Previous month
                    Button {
                        moveDate(to: selectedDate.adding(.month, value: -1))
                    } label: {
                        Label("ماه قبل", systemImage: "chevron.compact.right")
                            .customFont(style: .title1)
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(.tertiary)
                    
                    // MARK: - Today contents
                    VStack(alignment: .center, spacing: 3) {
                        Text(selectedDate, format: formatter.weekday(.wide))
                            .customFont(style: .largeTitle, weight: .bold)
                            .foregroundStyle(.primary)
                        
                        Text(selectedDate, format: formatter.year().month().day())
                            .customFont(style: .title1, weight: .bold)
                            .foregroundStyle(.accent)
                    }
                    .frame(minWidth: 168)
                    .padding(.horizontal, 25)
                    
                    // MARK: - Next month
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
                
                // MARK: - Progresses
                HStack(alignment: .center, spacing: 50) {
                    // MARK: - Year Progress
                    Gauge(value: selectedDate.daysPassedInYear()) {
                        Text("سال")
                            .customFont(style: .callout, weight: .light)
                            .foregroundStyle(.text)
                    } currentValueLabel: {
                        Text("\(String(format: "%.0f%%", selectedDate.daysPassedInYear() * 100))")
                    }
                    .tint(Color.accent)
                    .gaugeStyle(.accessoryLinearCapacity)
                    
                    // MARK: - Month Progress
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
                    let isToday = date.checkIsToday(date: Date())
                    
                    Text(date, format: formatter.day())
                        .customFont(style: .callout)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .dynamicTypeSize(.xSmall ... .medium)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isToday ? .white : date.checkIsToday(date: selectedDate) ? .focusedText : .primary)
                        .padding(8)
                        .background(isToday ? .accent : date.checkIsToday(date: selectedDate) ? .primary : .clear)
                        .background(.ultraThickMaterial)
                        .clipShape(.circle)
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 0.8)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                        .onTapGesture {
                            moveDate(to: date)
                        }
                }
                .frame(maxWidth: 300)

                // MARK: - EventView
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
                        }
                    }
                    .padding(.horizontal, 25)
                    .animation(.interactiveSpring(), value: selectedDate)
                }
                .padding(.top, 25)
            }
            .padding(.vertical)
        }
        #if os(iOS)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        #endif
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
        .onChange(of: scenePhase) { _ in
            selectedDate = Date()
        }
    }
}

#Preview {
    HomeView()
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.calendar, Calendar(identifier: .persian))
}
