//
//  MVVMCalendarCell.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 22/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MVVMCalendarCell: JTAppleCell {
    static let identifier = "MVCCalendarCell"
    private let todayView = UIView()
    private let dayLabel = UILabel()
    private let eventView = UIView()

    private var viewModel: CalendarCellViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        [todayView, dayLabel, eventView].addTo(self)

        setupLayouts()
        setupStyles()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }

    func setup(withVM VM: CalendarCellViewModel) {
        self.viewModel = VM
        bindViewModelToView()
    }
}

private extension MVVMCalendarCell {
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

    func bindViewModelToView() {
        guard let VM = self.viewModel else { return }
        dayLabel.text = VM.dayString
        dayLabel.isHidden = !VM.isInDate
        dayLabel.isHidden = !VM.isInDate
        todayView.isHidden = !VM.isDateToday
        dayLabel.textColor = VM.isDateToday ? UIColor.appPurple : .white
        eventView.isHidden = !VM.containsEvents
    }
}
