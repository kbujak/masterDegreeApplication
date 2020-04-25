//
//  CalendarViewControllerDelegate.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 13/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

protocol CalendarViewControllerDelegate: class {
    func didTapCreate()
    func didTapDate(withEvents events: [CalendarEvent])
}
