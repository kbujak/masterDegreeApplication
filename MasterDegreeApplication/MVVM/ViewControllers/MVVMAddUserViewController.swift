//
//  MVVMAddUserViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVVMAddUserViewController: UIViewController {
    private let backButton = UIButton()
    private let searchBar = UISearchBar()
    private let table = UITableView(frame: .zero, style: .grouped)

    private let viewModel: AddUserViewModel
    private weak var delegate: AddUserViewControllerDelegate?
    private let bag = DisposeBag()

    init(viewModel: AddUserViewModel, delegate: AddUserViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [backButton, searchBar, table].addTo(view)

        setupLayouts()
        setupStyles()
        setupTable()
        bindViewModelToView()
    }
}

// MARK: - Setup UI
private extension MVVMAddUserViewController {
    func setupLayouts() {
        backButton.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        backButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        searchBar.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 70, left: 20, bottom: 0, right: 20),
                                                  excludingEdge: .bottom)
        table.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                              excludingEdge: .top)
        table.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 20)
    }

    func setupStyles() {
        view.backgroundColor = .white
        backButton.setTitle(L10n.Common.back, for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        searchBar.placeholder = L10n.AddUserViewController.searchPlaceholder
    }

    func setupTable() {
        table.separatorStyle = .singleLine
        table.delegate = self
        table.dataSource = self
    }
}

// MARK: - Private layer
private extension MVVMAddUserViewController {
    func bindViewModelToView() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapBack() })
            .disposed(by: bag)
    }
}

// MARK: - TableView
extension MVVMAddUserViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "test123"
        return cell
    }
}
