//
//  Event.swift
//  JalaliCalendar
//
//  Created by armin on 2/4/21.
//

import Foundation

class EventService {

    static let shared = EventService()

    private init() {}

    func read(completion: @escaping (Result<[EventDetails], Error>)-> Void) {
        if let url = Bundle.main.url(forResource: "events", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let calendars = try JSONDecoder().decode(CalendarEvents.self, from: data)
                completion(.success(calendars.persianCalendar))
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    func getEvent(currentDate: Date = Date()) -> String {
        if let url = Bundle.main.url(forResource: "events", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let calendars = try JSONDecoder().decode(CalendarEvents.self, from: data)
                for item in calendars.persianCalendar {
                    if item.day == Int(JalaliHelper.DayEn.string(from: currentDate)) && item.month == Int(JalaliHelper.MonthEn.string(from: currentDate)) {
                        return item.title
                    }
                }
            } catch {
                print("error:\(error)")
            }
        }
        return "بدون مناسبت"
    }
}

// MARK: - Events
struct CalendarEvents: Codable {
    let persianCalendar, gregorianCalendar: [EventDetails]
}

// MARK: - Calendar
struct EventDetails: Codable, Hashable {
    let month, day: Int
    let title: String
    let holiday: Bool?
    let year: Int?
}
