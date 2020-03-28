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
@testable import MasterDegreeApplication

class AddUserViewModelTests: XCTestCase {
    private let bag = DisposeBag()

    func testUser_whenAllDataCorrect_thenItReturnsUser() {
        let realmProvider = RealmProviderMock()
        realmProvider.fetchUserWithPhraseCallClosure = { _ in Observable.just([userMock1, userMock2, userMock3]) }
        let context = ContextBuilder().with(realmProvider: RealmProviderMock()).build()
        let viewModel = AddUserViewModel(context: context)
        let input = AddUserViewModel.Input(
            search: Observable<String>.just("John")
        )
        let exp = expectation(description: "user event")

        let output = viewModel.transform(input: input)

        output.users
        .debug("yssdfsdf", trimOutput: true)
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(
            onNext: { users in
                exp.fulfill()
                XCTAssertEqual(1, users.count)
            }
        )
        .disposed(by: bag)

        wait(for: [exp], timeout: 4)
    }
}
