//
//  MVCUsersViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import PureLayout
import UIKit
import RxSwift
import RxCocoa

class MVCUsersViewController: UIViewController {
    private let inviteButton = UIButton()

    private let context: Context
    private weak var delegate: UsersViewControllerDelegate?
    private let bag = DisposeBag()

    init(context: Context, delegate: UsersViewControllerDelegate? = nil) {
        self.context = context
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [inviteButton].addTo(view)

        setupLayouts()
        setupStyles()
        bindViewModelToView()
    }
}

// MARK: - Setup UI
private extension MVCUsersViewController {
    func setupLayouts() {
        inviteButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        inviteButton.autoAlignAxis(toSuperviewMarginAxis: .vertical)
        inviteButton.autoSetDimension(.width, toSize: 100)
        inviteButton.autoSetDimension(.height, toSize: 50)
    }

    func setupStyles() {
        view.backgroundColor = .white
        inviteButton.setTitle(L10n.UsersViewController.invite, for: .normal)
        inviteButton.backgroundColor = .mainColor
        inviteButton.layer.cornerRadius = 25
    }
}

// MARK: - Private layer
private extension MVCUsersViewController {
    func bindViewModelToView() {
        inviteButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapInvite() })
            .disposed(by: bag)
    }
}
