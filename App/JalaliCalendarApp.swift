//
//  JalaliCalendarApp.swift
//  JalaliCalendar
//
//  Created by armin on 1/28/21.
//

import SwiftUI

@main
struct JalaliCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.calendar, .persianCalendar)
                .environment(\.locale, .init(identifier: "fa"))
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .defaultSize(width: 500, height: 700)
        #endif
    }
}
