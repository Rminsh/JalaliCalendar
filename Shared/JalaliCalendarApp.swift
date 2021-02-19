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
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                HomeView()
                    .environment(\.calendar, {
                        var calendar = Calendar(identifier: .persian)
                        calendar.locale = Locale(identifier: "fa")
                        return calendar
                    }())
            }
        }
    }
}
