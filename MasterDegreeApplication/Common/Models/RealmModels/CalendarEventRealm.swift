//
//  CalendarEventRealm.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 16/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RealmSwift

class CalendarEventRealm: Object {
    enum Properties: String {
        case id, ownerId, name, place, hours, minutes, date
    }

    @objc dynamic var id: String = ""
    @objc dynamic var ownerId: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var place: String = ""
    @objc dynamic var hours: Int = 0
    @objc dynamic var minutes: Int = 0
    @objc dynamic var date: Date = Date()

    convenience init(id: String,
                     ownerId: String,
                     name: String,
                     place: String,
                     hours: Int,
                     minutes: Int,
                     date: Date) {
        self.init()
        self.id = id
        self.ownerId = ownerId
        self.name = name
        self.place = place
        self.hours = hours
        self.minutes = minutes
        self.date = date
    }

    convenience init(calendarEvent: CalendarEvent) {
        self.init(id: calendarEvent.id,
                  ownerId: calendarEvent.ownerId,
                  name: calendarEvent.name,
                  place: calendarEvent.place,
                  hours: calendarEvent.hours,
                  minutes: calendarEvent.minutes,
                  date: calendarEvent.date)
    }

    override class func primaryKey() -> String? {
        return Properties.id.rawValue
    }
}
