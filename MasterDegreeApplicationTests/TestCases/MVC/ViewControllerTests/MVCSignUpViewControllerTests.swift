//
//  MVCSignUpViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVCSignUpViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNotNil() {
        let viewController = MVCSignUpViewController(context: ContextBuilder().build())
        XCTAssertNotNil(viewController)
    }
}
