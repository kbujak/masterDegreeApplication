//
//  MVVMAddUserViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVVMAddUserViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNotNil() {
        let viewModel = AddUserViewModel(context: ContextBuilder().build())
        let viewController = MVVMAddUserViewController(viewModel: viewModel)
        XCTAssertNotNil(viewController)
    }
}
