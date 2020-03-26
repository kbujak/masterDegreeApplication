//
//  SignUpViewModelTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import MasterDegreeApplication

class SignUpViewModelTests: XCTestCase {
    private let bag = DisposeBag()

    func testUser_whenAllDataCorrect_thenItReturnsUser() {
        let viewModel = SignUpViewModel(context: ContextBuilder().build())
        let input = SignUpViewModel.Input(
            username: Driver.just("test1"),
            password: Driver.just("test52"),
            retypePassword: Driver.just("test52"),
            registerTrigger: Driver<Void>.just(())
        )
        let exp = expectation(description: "user event")

        let output = viewModel.transform(input: input)

        output.user.subscribe(
            onNext: { user in
                exp.fulfill()
                XCTAssertNotNil(user)
            }
        )
        .disposed(by: bag)

        wait(for: [exp], timeout: 1)
    }

    func testUser_whenDataIncorrect_thenItReturnsNothing() {
        let viewModel = SignUpViewModel(context: ContextBuilder().build())
        let input = SignUpViewModel.Input(
            username: Driver.just("test1"),
            password: Driver.just("test2"),
            retypePassword: Driver.just("test52"),
            registerTrigger: Driver<Void>.just(())
        )
        let exp = expectation(description: "user event")

        let output = viewModel.transform(input: input)

        output.user.subscribe(onNext: { _ in exp.fulfill() }).disposed(by: bag)

        let result = XCTWaiter.wait(for: [exp], timeout: 1)
        guard case XCTWaiter.Result.timedOut = result else { XCTFail("User shouldn't pass"); return }
    }
}
