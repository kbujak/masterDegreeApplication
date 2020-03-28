//
//  MVCAddUserViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVCAddUserViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNotNil() {
        let viewController = MVCAddUserViewController(context: ContextBuilder().build())
        XCTAssertNotNil(viewController)
    }
}
