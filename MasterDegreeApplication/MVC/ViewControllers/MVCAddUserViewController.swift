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
    private let searchBar = UISearchBar()
    private let table = UITableView(frame: .zero, style: .grouped)

    private let context: Context
    private weak var delegate: AddUserViewControllerDelegate?
    private let bag = DisposeBag()
    private var users = BehaviorRelay<[User]>(value: [])

    init(context: Context, delegate: AddUserViewControllerDelegate? = nil) {
        self.context = context
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
private extension MVCAddUserViewController {
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
        table.allowsSelection = true
        table.allowsMultipleSelection = false
        table.register(AddUserCell.self, forCellReuseIdentifier: AddUserCell.identifier)
    }
}

// MARK: - Private layer
private extension MVCAddUserViewController {
    func bindViewModelToView() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.delegate?.didTapBack() })
            .disposed(by: bag)

        searchBar.rx.searchButtonClicked
            .map { [weak self] in self?.searchBar.text ?? "" }
            .subscribeOn(MainScheduler.asyncInstance)
            .flatMapLatest { [weak self] phrase -> Observable<[User]> in
                guard let `self` = self else { return Observable.error(AppErrors.unknownError) }
                return self.context.realmProvider
                    .fetchUser(withPhrase: phrase)
                    .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            }
            .bind(to: users)
            .disposed(by: bag)

        table.rx.itemSelected
            .map { $0.item }
            .asDriver(onErrorRecover: { _ in Driver.never() })
            .drive(onNext: { [weak self] index in self?.inviteUser(atIndex: index) })
            .disposed(by: bag)

        users.bind(
            to: table.rx.items(cellIdentifier: AddUserCell.identifier, cellType: AddUserCell.self)
        ) { [weak self] _, user, cell in
            guard let `self` = self else { return }

            let isFriend = self.isFriend(user)
            cell.selectionStyle = .none
            cell.textLabel?.text = isFriend ? "(Added) \(user.username)" : user.username
        }
        .disposed(by: bag)
    }

    func inviteUser(atIndex index: Int) {
        guard
            let currentUser = context.userDataCache.user,
            !currentUser.friendIds.contains(users.value[index].id)
        else { return }

        context.realmProvider.addFriend(withUserId: users.value[index].id, forUser: currentUser)
            .subscribe(
                onNext: { [weak self] user in
                    guard let `self` = self else { return }
                    self.context.userDataCache.update(user: user)
                    self.users.accept(self.users.value)
                }
            )
            .disposed(by: bag)
    }

    func isFriend(_ user: User) -> Bool {
        guard let logedInUser = context.userDataCache.user else { return false }
        return logedInUser.friendIds.contains(user.id)
    }
}
