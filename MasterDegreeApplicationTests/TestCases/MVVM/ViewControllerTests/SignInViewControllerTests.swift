//
//  SignInViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class SignInViewControllerTest: XCTestCase {

    func testAppCoordinator_whenStart_thenVCIsNavigationController() {
        let viewModel = SignInViewModel()
        let viewController = SignInViewController(viewModel: viewModel)
        XCTAssertNotNil(viewController)
    }
}
