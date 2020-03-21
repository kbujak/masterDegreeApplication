//
//  SignInCoordinatorTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class SignInCoordinatorTest: XCTestCase {

    func testAppCoordinator_whenStart_thenVCIsNavigationController() {
        let navigationVC = UINavigationController()
        let coordinator = SignInCoordinator()
        coordinator.start(in: navigationVC)

        guard let VC = coordinator.VC else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(VC is SignInViewController)
    }
}
