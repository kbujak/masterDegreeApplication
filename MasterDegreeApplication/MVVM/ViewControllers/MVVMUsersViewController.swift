//
//  MVVMUsersViewController.swift
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

class MVVMUsersViewController: UIViewController {
    private let inviteButton = UIButton()
    private let table = UITableView(frame: .zero, style: .grouped)

    private let viewModel: UsersViewModel
    private weak var delegate: UsersViewControllerDelegate?
    private let bag = DisposeBag()

    init(viewModel: UsersViewModel, delegate: UsersViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [table, inviteButton].addTo(view)

        setupLayouts()
        setupStyles()
        setupTable()
        bindViewModelToView()
    }
}

// MARK: - Setup UI
private extension MVVMUsersViewController {
    func setupLayouts() {
        inviteButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        inviteButton.autoAlignAxis(toSuperviewMarginAxis: .vertical)
        inviteButton.autoSetDimension(.width, toSize: 100)
        inviteButton.autoSetDimension(.height, toSize: 50)

        table.autoPinEdgesToSuperviewSafeArea()
    }

    func setupStyles() {
        view.backgroundColor = .white
        inviteButton.setTitle(L10n.UsersViewController.invite, for: .normal)
        inviteButton.backgroundColor = .appPurple
        inviteButton.layer.cornerRadius = 25
    }

    func setupTable() {
        table.allowsSelection = true
        table.allowsMultipleSelection = false
        table.register(AddUserCell.self, forCellReuseIdentifier: AddUserCell.identifier)
    }
}

// MARK: - Private layer
private extension MVVMUsersViewController {
    func bindViewModelToView() {
        inviteButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapInvite() })
            .disposed(by: bag)

        let input = UsersViewModel.Input()
        let output = viewModel.transform(input: input)

        output.friends.bind(
            to: table.rx.items(cellIdentifier: AddUserCell.identifier, cellType: AddUserCell.self)
        ) { _, user, cell in
            cell.selectionStyle = .none
            cell.textLabel?.text = user.username
        }
        .disposed(by: bag)
    }
}
