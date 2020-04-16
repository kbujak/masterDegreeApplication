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

extension CalendarEvent: Equatable {
    static func == (lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
        return lhs.id == rhs.id
    }
}
