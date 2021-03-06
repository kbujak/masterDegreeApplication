//
//  MVVMSignInViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVVMSignInViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNotNil() {
        let viewModel = SignInViewModel(context: ContextBuilder().build())
        let viewController = MVVMSignInViewController(viewModel: viewModel)
        XCTAssertNotNil(viewController)
    }
}
