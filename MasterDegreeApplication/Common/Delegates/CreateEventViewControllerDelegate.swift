//
//  CreateEventViewControllerDelegate.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 13/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

protocol CreateEventViewControllerDelegate: class {
    func didTapBack()
    func didCreateCalendarEvent(_ event: CalendarEvent)
}
