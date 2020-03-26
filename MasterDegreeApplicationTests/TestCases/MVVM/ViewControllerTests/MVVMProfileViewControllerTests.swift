//
//  MVVMProfileViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVVMProfileViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNotNil() {
        let viewModel = ProfileViewModel(context: ContextBuilder().build())
        let viewController = MVVMProfileViewController(viewModel: viewModel)
        XCTAssertNotNil(viewController)
    }
}
