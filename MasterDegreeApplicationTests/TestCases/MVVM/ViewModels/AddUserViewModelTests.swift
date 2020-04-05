//
//  AddUserViewModelTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import MasterDegreeApplication

class AddUserViewModelTests: XCTestCase {
    private var bag: DisposeBag!

    override func setUp() {
        super.setUp()
        self.bag = DisposeBag()
    }

    override func tearDown() {
        self.bag = nil
        super.tearDown()
    }

    func testUser_whenAllDataCorrect_thenItReturnsUser() {
        let realmProvider = configureRealmProvider(fetchedUsers: [userMock1, userMock2, userMock3])
        let context = ContextBuilder().with(realmProvider: realmProvider).build()

        let viewModel = AddUserViewModel(context: context)
        let output = viewModel.transform(input: configureViewModelInput(context: context, search: "Kowal"))

        let exp = expectation(description: "test123")

        output.users.skip(1).subscribe(
            onNext: { users in
                print(users)
                exp.fulfill()
                XCTAssertEqual(3, users.count)
            }
        )
        .disposed(by: bag)

        wait(for: [exp], timeout: 1)
    }

    func testAddUser_whenUserDataCache_thenCalled() {
        let realmProvider = configureRealmProvider(fetchedUsers: [userMock1, userMock2, userMock3],
                                                   addedFriend: userMock1)
        let dataCache = configureUserDataCache(user: userMock1)
        let context = ContextBuilder()
            .with(realmProvider: realmProvider)
            .with(userDataCache: dataCache)
            .build()

        let viewModel = AddUserViewModel(context: context)
        let output = viewModel.transform(input: configureViewModelInput(context: context, addedUserIndex: 1))

        let exp = expectation(description: "test123")

        output.users.skip(2).subscribe(
            onNext: { _ in
                exp.fulfill()
                print(realmProvider.addFriendWithUserIdCallCount)
                XCTAssertEqual(1, realmProvider.addFriendWithUserIdCallCount)
            }
        )
        .disposed(by: bag)

        wait(for: [exp], timeout: 1)
    }

    func testAddUser_whenNoUserDataCache_thenNotCalled() {
        let realmProvider = configureRealmProvider(fetchedUsers: [userMock1, userMock2, userMock3],
                                                   addedFriend: userMock1)
        let context = ContextBuilder().with(realmProvider: realmProvider).build()

        let viewModel = AddUserViewModel(context: context)
        let output = viewModel.transform(input: configureViewModelInput(context: context, addedUserIndex: 1))

        let exp = expectation(description: "Add user event")

        output.users.skip(2).subscribe(onNext: { _ in exp.fulfill() }).disposed(by: bag)

        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        guard case XCTWaiter.Result.timedOut = result else { XCTFail("User shouldn't pass"); return }
    }

    private func configureRealmProvider(fetchedUsers: [User], addedFriend: User? = nil) -> RealmProviderMock {
        let realmProvider = RealmProviderMock()
        realmProvider.fetchUserWithPhraseCallClosure = { _ in Observable.just(fetchedUsers) }
        if let addedUser = addedFriend {
            realmProvider.addFriendWithUserIdCallClosure = { _, _ in Observable.just(addedUser) }
        }
        return realmProvider
    }

    private func configureUserDataCache(user: User) -> UserDataCacheMock {
        let dataCache = UserDataCacheMock()
        dataCache.user = user
        return dataCache
    }

    private func configureViewModelInput(context: Context,
                                         search: String = "",
                                         addedUserIndex: Int? = nil) -> AddUserViewModel.Input {
        var addUserTrigger = Driver<Int>.empty()
        if let addedUserIndex = addedUserIndex {
            addUserTrigger = Observable.just(addedUserIndex)
                .subscribeOn(MainScheduler.asyncInstance)
                .asDriver(onErrorJustReturn: 1)
        }
        return AddUserViewModel.Input(
            search: Observable<String>.just(search),
            addUserTrigger: addUserTrigger
        )
    }
}
