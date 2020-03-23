//
//  MVVMSignUpViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVVMSignUpViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNotNil() {
        let viewModel = SignUpViewModel()
        let viewController = MVVMSignUpViewController(viewModel: viewModel)
        XCTAssertNotNil(viewController)
    }
}
