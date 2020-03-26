//
//  MVCCalendarViewControllerTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVCCalendarViewControllerTests: XCTestCase {

    func testController_whenStart_thenVCIsNotNil() {
        let viewController = MVCCalendarViewController(context: ContextBuilder().build())
        XCTAssertNotNil(viewController)
    }
}
