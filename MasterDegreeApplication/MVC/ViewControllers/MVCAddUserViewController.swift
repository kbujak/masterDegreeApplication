//
//  MVCAddUserViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVCAddUserViewController: UIViewController {
    private let backButton = UIButton()
    private let context: Context
    private weak var delegate: AddUserViewControllerDelegate?
    private let bag = DisposeBag()

    init(context: Context, delegate: AddUserViewControllerDelegate? = nil) {
        self.context = context
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [backButton].addTo(view)

        setupLayouts()
        setupStyles()
        bindViewModelToView()
    }
}

// MARK: - Setup UI
private extension MVCAddUserViewController {
    func setupLayouts() {
        backButton.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        backButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
    }

    func setupStyles() {
        view.backgroundColor = .white
        backButton.setTitle(L10n.Common.back, for: .normal)
        backButton.setTitleColor(.black, for: .normal)
    }
}

// MARK: - Private layer
private extension MVCAddUserViewController {
    func bindViewModelToView() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapBack() })
            .disposed(by: bag)
    }
}