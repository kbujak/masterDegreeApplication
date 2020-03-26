//
//  MVCUsersViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVCUsersViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNotNil() {
        let viewController = MVCUsersViewController(context: ContextBuilder().build())
        XCTAssertNotNil(viewController)
    }
}
