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
    private var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        self.bag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        self.bag = nil
        self.scheduler = nil
        super.tearDown()
    }

    func testUser_whenAllDataCorrect_thenItReturnsUser() {
        let realmProvider = RealmProviderMock()
        realmProvider.fetchUserWithPhraseCallClosure = { _ in Observable.just([userMock1, userMock2, userMock3]) }
        let context = ContextBuilder().with(realmProvider: realmProvider).build()
        let viewModel = AddUserViewModel(context: context)
        let input = AddUserViewModel.Input(
            search: Observable<String>.just("Kowal"),
            addUserTrigger: Driver.empty()
        )
        let exp = expectation(description: "test123")

        let output = viewModel.transform(input: input)

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

    func testAddUser() {
        let realmProvider = RealmProviderMock()
        realmProvider.fetchUserWithPhraseCallClosure = { _ in Observable.just([userMock1, userMock2, userMock3]) }
        realmProvider.inviteUserCallClosure = { _ in Observable.just(userMock1) }
        let context = ContextBuilder().with(realmProvider: realmProvider).build()

        let viewModel = AddUserViewModel(context: context)
        let input = AddUserViewModel.Input(
            search: Observable<String>.just(""),
            addUserTrigger: Driver<Int>.just(1)
        )
        let exp = expectation(description: "test123")
        let output = viewModel.transform(input: input)

        output.users.skip(1).subscribe(
            onNext: { _ in
                exp.fulfill()
                print(realmProvider.inviteUserCallCount)
                XCTAssertEqual(1, realmProvider.inviteUserCallCount)
            }
        )
        .disposed(by: bag)

        wait(for: [exp], timeout: 1)
    }
}
