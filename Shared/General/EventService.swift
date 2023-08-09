//
//  Event.swift
//  JalaliCalendar
//
//  Created by armin on 2/4/21.
//

import Foundation

struct CalendarEvents: Codable {
    let persianCalendar, gregorianCalendar: [EventDetails]
    
    static var all: CalendarEvents {
        if let url = Bundle.main.url(forResource: "events", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let calendars = try JSONDecoder().decode(CalendarEvents.self, from: data)
                return calendars
            } catch {
                print("💥🗓️ Failed to load calendars: \(error)")
                return .init(persianCalendar: [], gregorianCalendar: [])
            }
        } else {
            return .init(persianCalendar: [], gregorianCalendar: [])
        }
    }
    
    static var persianCalendarEvents: [EventDetails] {
        self.all.persianCalendar
    }
}

struct EventDetails: Codable, Hashable {
    let month, day: Int
    let title: String
    let holiday: Bool?
    let year: Int?
}
