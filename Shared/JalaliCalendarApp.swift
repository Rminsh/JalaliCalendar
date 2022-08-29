//
//  JalaliCalendarApp.swift
//  Shared
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
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        #endif
    }
}
