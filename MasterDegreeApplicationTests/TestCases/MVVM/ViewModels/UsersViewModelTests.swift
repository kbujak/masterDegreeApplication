//
//  UsersViewModelTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import MasterDegreeApplication

class UsersViewModelTests: XCTestCase {
    private var bag: DisposeBag!

    override func setUp() {
        super.setUp()
        self.bag = DisposeBag()
    }

    override func tearDown() {
        self.bag = nil
        super.tearDown()
    }

    func testfriends_whenInit_thenItReturnsUsers() {
        let realmProvider = RealmProviderMock()
        realmProvider.fetchFriendsForUserCallClosure = { _ in Observable.just([userMock1, userMock2, userMock3])}

        let userDataCache = UserDataCacheMock()
        userDataCache.user = userMock1

        let context = ContextBuilder()
            .with(realmProvider: realmProvider)
            .with(userDataCache: userDataCache)
            .build()

        let viewModel = UsersViewModel(context: context)
        let output = viewModel.transform(input: UsersViewModel.Input())

        let exp = expectation(description: "Users event")

        output.friends
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.asyncInstance)
            .skip(1).subscribe(
            onNext: { _ in
                exp.fulfill()
                XCTAssertEqual(1, realmProvider.fetchFriendsForUserCallCount)
            }
        )
        .disposed(by: bag)

        wait(for: [exp], timeout: 2)
    }
}
