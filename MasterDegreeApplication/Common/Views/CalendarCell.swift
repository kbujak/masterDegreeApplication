//
//  CalendarCell.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 22/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    static let identifier = "CalendarCell"
    private let day = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [day].addTo(self)

        setupLayouts()
        setupStyles()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setup(withDate date: Date, isInDate: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.string(from: date)
        day.text = formatter.string(from: date)
        day.isHidden = !isInDate
    }
}

private extension CalendarCell {
    func setupLayouts() {
        day.autoCenterInSuperview()
    }

    func setupStyles() {
        day.textColor = .white
    }
}
