//
//  MVVMCreateEventViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 13/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVVMCreateEventViewController: UIViewController {
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let nameTextfield = BorderedTextField()
    private let placeTextfield = BorderedTextField()
    private let dateTextField = BorderedTextField()
    private let timeTextField = BorderedTextField()
    private let submitButton = RoundedGrayButton()
    private let datePicker = UIDatePicker()
    private let hourPicker = UIDatePicker()

    private let viewModel: CreateEventViewModel
    private weak var delegate: CreateEventViewControllerDelegate?
    private let bag = DisposeBag()

    init(viewModel: CreateEventViewModel, delegate: CreateEventViewControllerDelegate? = nil) {
        self.viewModel = viewModel
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
private extension MVVMCreateEventViewController {
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
private extension MVVMCreateEventViewController {
    func bindViewModelToView() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapBack() })
            .disposed(by: bag)

        let input = CreateEventViewModel.Input(
            date: datePicker.rx.date.asObservable(),
            hour: hourPicker.rx.date.asObservable(),
            name: nameTextfield.rx.text.asObservable(),
            place: placeTextfield.rx.text.asObservable(),
            submitTrigger: submitButton.rx.tap.asDriver()
        )

        let output = viewModel.transform(input: input)

        output.dateString.drive(dateTextField.rx.text).disposed(by: bag)
        output.timeString.drive(timeTextField.rx.text).disposed(by: bag)

        output.calendarEvent
            .drive(onNext: { [weak self] event in self?.delegate?.didCreateCalendarEvent(event) })
            .disposed(by: bag)
    }
}

// MARK: - Actions
private extension MVVMCreateEventViewController {
    func setupActions() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }

    @objc func didTapView() {
        view.endEditing(true)
    }
}
