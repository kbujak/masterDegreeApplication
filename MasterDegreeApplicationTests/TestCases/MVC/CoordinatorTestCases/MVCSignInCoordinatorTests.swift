//
//  MVCSignInCoordinatorTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVCSignInCoordinatorTests: XCTestCase {

    func testCoordinator_whenStart_thenVCIsNavigationController() {
        let navigationVC = UINavigationController()
        let coordinator = MVCSignInCoordinator(context: ContextBuilder().build())
        coordinator.start(in: navigationVC)

        guard let VC = coordinator.VC else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(VC is UINavigationController)
    }
}
