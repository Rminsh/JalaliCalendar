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
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .defaultSize(width: 500, height: 700)
        #endif
    }
}
