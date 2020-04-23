//
//  CalendarCellViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 23/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import JTAppleCalendar

protocol CalendarCellViewModel {
    var dayString: String { get }
    var isInDate: Bool { get }
    var isDateToday: Bool { get }
    var containsEvents: Bool { get }
}

class CalendarCellViewModelImpl: CalendarCellViewModel {
    private let date: Date
    private let cellState: CellState
    private let events: [CalendarEvent]

    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    var isInDate: Bool {
        return cellState.dateBelongsTo == .thisMonth
    }
    var isDateToday: Bool {
        let calendar = Calendar.current
        let cellDateComponnets = calendar.dateComponents([.year, .month, .day], from: cellState.date)
        let todayDateComponnets = calendar.dateComponents([.year, .month, .day], from: Date())
        return cellDateComponnets == todayDateComponnets
    }
    var containsEvents: Bool {
        return !events.isEmpty
    }

    init(date: Date, cellState: CellState, events: [CalendarEvent]) {
        self.date = date
        self.cellState = cellState
        self.events = events
    }
}
