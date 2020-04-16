//
//  MVCCreateEventViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 15/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVCCreateEventViewController: UIViewController {
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let nameTextfield = BorderedTextField()
    private let placeTextfield = BorderedTextField()
    private let dateTextField = BorderedTextField()
    private let timeTextField = BorderedTextField()
    private let submitButton = RoundedGrayButton()
    private let datePicker = UIDatePicker()
    private let hourPicker = UIDatePicker()

    private var date: Date?
    private var hours: Int?
    private var minutes: Int?
    private var nameRelay = BehaviorRelay<String?>(value: nil)
    private var placeRelay = BehaviorRelay<String?>(value: nil)
    private var timeRelay = BehaviorRelay<String>(value: "")
    private let context: Context
    private weak var delegate: CreateEventViewControllerDelegate?
    private let bag = DisposeBag()

    init(context: Context, delegate: CreateEventViewControllerDelegate? = nil) {
        self.context = context
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [backButton,
         titleLabel,
         nameTextfield,
         placeTextfield,
         dateTextField,
         timeTextField,
         submitButton].addTo(view)

        setupLayouts()
        setupStyles()
        setupActions()
        bindViewModelToView()

        dateTextField.inputView = datePicker
        timeTextField.inputView = hourPicker
    }
}

// MARK: - Setup UI
private extension MVCCreateEventViewController {
    func setupLayouts() {
        backButton.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        backButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)

        titleLabel.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 100, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        nameTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 250, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        placeTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 305, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        dateTextField.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 360, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        timeTextField.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 415, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        submitButton.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 480, left: 100, bottom: 0, right: 100),
            excludingEdge: .bottom
        )
    }

    func setupStyles() {
        view.backgroundColor = .white
        backButton.setTitle(L10n.Common.back, for: .normal)
        backButton.setTitleColor(.black, for: .normal)

        titleLabel.text = L10n.CreateEventViewController.title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)

        nameTextfield.placeholder = L10n.CreateEventViewController.nameTextfield
        placeTextfield.placeholder = L10n.CreateEventViewController.placeTextfield

        datePicker.datePickerMode = .date

        hourPicker.datePickerMode = .time

        submitButton.setTitle(L10n.Common.create, for: .normal)
    }
}

// MARK: - Private layer
private extension MVCCreateEventViewController {
    func bindViewModelToView() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapBack() })
            .disposed(by: bag)

        let date = datePicker.rx.date.asObservable()

        date.share()
            .subscribe(
                onNext: { [weak self] date in self?.date = date },
                onError: { error in print(error) }
            )
            .disposed(by: bag)

        hourPicker.rx.date.asObservable()
            .subscribe(
                onNext: { [weak self] date in
                    let calendar = Calendar.current
                    let comp = calendar.dateComponents([.hour, .minute], from: date)
                    let hours = comp.hour
                    let minutes = comp.minute
                    self?.hours = hours
                    self?.minutes = minutes
                    self?.timeTextField.text = "\(hours ?? 0):\(minutes ?? 0)"
                },
                onError: { error in print(error) }
            )
            .disposed(by: bag)

        nameTextfield.rx.text.asObservable().bind(to: nameRelay).disposed(by: bag)

        placeTextfield.rx.text.asObservable().bind(to: placeRelay).disposed(by: bag)

        date.share()
            .map { date -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                return dateFormatter.string(from: date)
            }
            .asDriver(onErrorRecover: { _ in Driver.never() })
            .drive(dateTextField.rx.text)
            .disposed(by: bag)

        submitButton.rx.tap.asDriver().drive(onNext: { [weak self] in self?.submit() }).disposed(by: bag)
    }
}

// MARK: - Actions
private extension MVCCreateEventViewController {
    func setupActions() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }

    @objc func didTapView() {
        view.endEditing(true)
    }

    func submit() {
        guard
            let date = date, let hours = hours, let minutes = minutes, let name = nameRelay.value, let place = placeRelay.value,
            !name.isEmpty, name != "",
            !place.isEmpty, place != "",
            let user = context.userDataCache.user
        else { return}

        let event = CalendarEvent(ownerId: user.id,
                                  name: name,
                                  place: place,
                                  hours: hours,
                                  minutes: minutes,
                                  date: date)

        context.realmProvider.createCalendarEvent(withCalendarEvent: event)
            .subscribe(
                onNext: { [weak self] event in self?.delegate?.didCreateCalendarEvent(event) },
                onError: { error in print(error) }
            )
            .disposed(by: bag)
    }
}
