//
//  MVCCalendarCell.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 23/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MVCCalendarCell: JTAppleCell {
    static let identifier = "MVCCalendarCell"
    private let todayView = UIView()
    private let dayLabel = UILabel()
    private let eventView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [todayView, dayLabel, eventView].addTo(self)

        setupLayouts()
        setupStyles()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        dayLabel.isHidden = true
        dayLabel.isHidden = true
        todayView.isHidden = true
        eventView.isHidden = true
    }

    func setup(date: Date, cellState: CellState, events: [CalendarEvent]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        dayLabel.text = formatter.string(from: date)

        dayLabel.isHidden = !(cellState.dateBelongsTo == .thisMonth)

        let calendar = Calendar.current
        let cellDateComponnets = calendar.dateComponents([.year, .month, .day], from: cellState.date)
        let todayDateComponnets = calendar.dateComponents([.year, .month, .day], from: Date())
        todayView.isHidden = !(cellDateComponnets == todayDateComponnets)

        dayLabel.textColor = (cellDateComponnets == todayDateComponnets) ? UIColor.appPurple : .white

        eventView.isHidden = events.isEmpty
    }
}

private extension MVCCalendarCell {
    func setupLayouts() {
        dayLabel.autoCenterInSuperview()

        todayView.autoCenterInSuperview()
        todayView.autoSetDimension(.width, toSize: 30)
        todayView.autoSetDimension(.height, toSize: 30)

        eventView.autoCenterInSuperview()
        eventView.autoSetDimension(.width, toSize: 30)
        eventView.autoSetDimension(.height, toSize: 30)
    }

    func setupStyles() {
        todayView.backgroundColor = .white
        todayView.layer.cornerRadius = 15
        todayView.isHidden = true

        dayLabel.textColor = .white

        eventView.layer.cornerRadius = 15
        eventView.layer.borderWidth = 1
        eventView.layer.borderColor = UIColor.appGreen.cgColor
    }
}
