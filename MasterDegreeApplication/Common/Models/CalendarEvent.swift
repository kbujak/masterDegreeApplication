//
//  CalendarEvent.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 15/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RealmSwift

struct CalendarEvent {
    let id: String
    let ownerId: String
    let name: String
    let place: String
    let hours: Int
    let minutes: Int
    let date: Date

    init(id: String = UUID().uuidString,
         ownerId: String,
         name: String,
         place: String,
         hours: Int,
         minutes: Int,
         date: Date) {
        self.id = id
        self.ownerId = ownerId
        self.name = name
        self.place = place
        self.hours = hours
        self.minutes = minutes
        self.date = date
    }

    init(realm: CalendarEventRealm) {
        self.init(id: realm.id,
                  ownerId: realm.ownerId,
                  name: realm.name,
                  place: realm.place,
                  hours: realm.hours,
                  minutes: realm.minutes,
                  date: realm.date)
    }

    func createRealm() -> CalendarEventRealm {
        return CalendarEventRealm(calendarEvent: self)
    }
}

extension CalendarEvent: Comparable {
    static func == (lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
        return lhs.date == rhs.date && lhs.hours == rhs.hours && lhs.minutes == rhs.minutes
    }

    static func < (lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
        let calendar = Calendar.current
        let lhsComponents = calendar.dateComponents([.year, .month, .day], from: lhs.date)
        let rhsComponents = calendar.dateComponents([.year, .month, .day], from: rhs.date)

        if lhsComponents.year! < rhsComponents.year! {
            return true
        } else if lhsComponents.year! > rhsComponents.year! {
            return false
        } else {
            if lhsComponents.month! < rhsComponents.month! {
                return true
            } else if lhsComponents.month! > rhsComponents.month! {
                return false
            } else {
                if lhsComponents.day! < rhsComponents.day! {
                    return true
                } else if lhsComponents.day! > rhsComponents.day! {
                    return false
                } else {
                    if lhs.hours < rhs.hours {
                        return true
                    } else if lhs.hours > rhs.hours {
                        return false
                    } else {
                        if lhs.minutes < rhs.minutes {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
    }
}
