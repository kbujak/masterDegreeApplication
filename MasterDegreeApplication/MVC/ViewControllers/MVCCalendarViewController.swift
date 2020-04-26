//
//  MVCCalendarViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import JTAppleCalendar

class MVCCalendarViewController: UIViewController {
    private let createButton = UIButton()
    private let topContainer = UIView()
    private let monthLabel = UILabel()
    private let monday = UILabel()
    private let tuesday = UILabel()
    private let wednesday = UILabel()
    private let thursday = UILabel()
    private let friday = UILabel()
    private let saturday = UILabel()
    private let sunday = UILabel()
    private let calendarView = JTAppleCalendarView()
    private var gradientLayer: CAGradientLayer?

    private let context: Context
    private let bag = DisposeBag()
    private weak var delegate: CalendarViewControllerDelegate?
    private var events: [CalendarEvent] = []

    init(context: Context, delegate: CalendarViewControllerDelegate? = nil) {
        self.context = context
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [topContainer, createButton].addTo(view)
        [monthLabel, calendarView].addTo(topContainer)
        [monday, tuesday, wednesday, thursday, friday, saturday, sunday].addTo(topContainer)

        setupLayouts()
        setupStyles()
        setupCalendar()
        setupMonthLabel()
        bindViewModelToView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layer = self.gradientLayer {
            layer.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = topContainer.frame
        gradientLayer.colors = [UIColor.appPurple.cgColor, UIColor.appBlue.cgColor]
        gradientLayer.locations = [0.0, 0.95]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        topContainer.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
}

// MARK: - Setup UI
private extension MVCCalendarViewController {
    func setupLayouts() {
        createButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        createButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        createButton.autoSetDimension(.width, toSize: 50)
        createButton.autoSetDimension(.height, toSize: 50)

        topContainer.autoPinEdge(toSuperviewEdge: .top)
        topContainer.autoPinEdge(toSuperviewEdge: .left)
        topContainer.autoPinEdge(toSuperviewEdge: .right)
        topContainer.autoPinEdge(toSuperviewSafeArea: .bottom)

        monthLabel.autoPinEdge(.bottom, to: .top, of: monday, withOffset: -30)
        monthLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)

        monday.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        monday.autoPinEdge(.bottom, to: .top, of: calendarView, withOffset: -10)

        tuesday.autoPinEdge(.left, to: .right, of: monday, withOffset: 30)
        tuesday.autoPinEdge(.bottom, to: .top, of: calendarView, withOffset: -10)

        wednesday.autoPinEdge(.left, to: .right, of: tuesday, withOffset: 30)
        wednesday.autoPinEdge(.bottom, to: .top, of: calendarView, withOffset: -10)

        thursday.autoPinEdge(.left, to: .right, of: wednesday, withOffset: 30)
        thursday.autoPinEdge(.bottom, to: .top, of: calendarView, withOffset: -10)

        friday.autoPinEdge(.left, to: .right, of: thursday, withOffset: 37)
        friday.autoPinEdge(.bottom, to: .top, of: calendarView, withOffset: -10)

        saturday.autoPinEdge(.left, to: .right, of: friday, withOffset: 37)
        saturday.autoPinEdge(.bottom, to: .top, of: calendarView, withOffset: -10)

        sunday.autoPinEdge(.left, to: .right, of: saturday, withOffset: 35)
        sunday.autoPinEdge(.bottom, to: .top, of: calendarView, withOffset: -10)

        calendarView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 250, left: 0, bottom: 250, right: 0))
    }

    func setupStyles() {
        view.backgroundColor = .white
        createButton.setTitle("+", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .regular)

        calendarView.backgroundColor = .clear

        monthLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        monthLabel.textColor = .white
        monthLabel.text = "December"

        monday.font = UIFont.systemFont(ofSize: 13)
        monday.textColor = .white
        monday.text = "Mon."

        tuesday.font = UIFont.systemFont(ofSize: 13)
        tuesday.textColor = .white
        tuesday.text = "Tue."

        wednesday.font = UIFont.systemFont(ofSize: 13)
        wednesday.textColor = .white
        wednesday.text = "Wed."

        thursday.font = UIFont.systemFont(ofSize: 13)
        thursday.textColor = .white
        thursday.text = "Thu."

        friday.font = UIFont.systemFont(ofSize: 13)
        friday.textColor = .white
        friday.text = "Fri."

        saturday.font = UIFont.systemFont(ofSize: 13)
        saturday.textColor = .white
        saturday.text = "Sat."

        sunday.font = UIFont.systemFont(ofSize: 13)
        sunday.textColor = .white
        sunday.text = "Sun."
    }
}

// MARK: - Private layer
private extension MVCCalendarViewController {
    func bindViewModelToView() {
        createButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapCreate() })
            .disposed(by: bag)

        if let user = context.userDataCache.user {
            let accumulatedIds = [user.id] + user.friendIds
            context.realmProvider.fetchEvents(forUserIds: accumulatedIds)
                .subscribe(
                    onNext: { [weak self] events in
                        self?.calendarView.reloadData()
                        self?.events = events
                    }
                )
                .disposed(by: bag)
        }
    }

    func setupCalendar() {
        calendarView.register(MVCCalendarCell.self, forCellWithReuseIdentifier: MVCCalendarCell.identifier)
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.isPagingEnabled = true
        calendarView.scrollDirection = .horizontal
    }

    func setupMonthLabel() {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        self.monthLabel.text = monthOfYear[month]
    }
}

// MARK: - JTAppleCalendar
extension MVCCalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: today),
                                                      month: calendar.component(.month, from: today),
                                                      day: 1))
        let endDate = calendar.date(byAdding: .year, value: 1, to: startDate!)
        let config = ConfigurationParameters(startDate: startDate ?? Date(),
                                             endDate: endDate ?? Date(),
                                             numberOfRows: 6,
                                             calendar: Calendar.current,
                                             generateInDates: .forAllMonths,
                                             generateOutDates: .tillEndOfRow,
                                             firstDayOfWeek: .monday,
                                             hasStrictBoundaries: true)
        return config
    }

    func calendar(_ calendar: JTAppleCalendarView,
                  cellForItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: MVCCalendarCell.identifier,
                                                       for: indexPath)
        if let calendarCell = cell as? MVCCalendarCell {
            let events = getEvents(fromDate: date)
            calendarCell.setup(date: date, cellState: cellState, events: events)
        }
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView,
                  willDisplay cell: JTAppleCell,
                  forItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) {
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let calendar = Calendar.current
        var dict = [Int: Int]()
        for date in visibleDates.monthDates.map({ $0.0 }) {
            let month = calendar.component(.month, from: date)
            if let value = dict[month] {
                dict.updateValue(value + 1, forKey: month)
            } else {
                dict[month] = 1
            }
        }

        if let month = dict.sorted(by: { lhs, rhs in lhs.value > rhs.value }).first {
            self.monthLabel.text = monthOfYear[month.key]
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let events = getEvents(fromDate: date)
        delegate?.didTapDate(withEvents: events)
    }

    private func getEvents(fromDate date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let filteredEvents = events.filter { event -> Bool in
            let eventComponents = calendar.dateComponents([.year, .month, .day], from: event.date)
            return eventComponents == dateComponents
        }
        return filteredEvents
    }
}
