//
//  MVVMCalendarViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVVMCalendarViewController: UIViewController {
    private let createButton = UIButton()

    private let viewModel: CalendarViewModel
    private let bag = DisposeBag()
    private weak var delegate: CalendarViewControllerDelegate?

    init(viewModel: CalendarViewModel, delegate: CalendarViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [createButton].addTo(view)

        setupLayouts()
        setupStyles()
        bindViewModelToView()
    }
}

// MARK: - Setup UI
private extension MVVMCalendarViewController {
    func setupLayouts() {
        createButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        createButton.autoAlignAxis(toSuperviewMarginAxis: .vertical)
        createButton.autoSetDimension(.width, toSize: 100)
        createButton.autoSetDimension(.height, toSize: 50)
    }

    func setupStyles() {
        view.backgroundColor = .white
        createButton.setTitle(L10n.Common.create, for: .normal)
        createButton.backgroundColor = .mainColor
        createButton.layer.cornerRadius = 25
    }
}

// MARK: - Private layer
private extension MVVMCalendarViewController {
    func bindViewModelToView() {
        createButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapCreate() })
            .disposed(by: bag)
    }
}
