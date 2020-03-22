//
//  MVCSignInViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVCSignInViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNavigationController() {
        let viewController = MVCSignInViewController()
        XCTAssertNotNil(viewController)
    }
}
