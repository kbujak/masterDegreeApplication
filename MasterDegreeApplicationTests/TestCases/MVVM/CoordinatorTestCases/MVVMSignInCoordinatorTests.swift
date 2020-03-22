//
//  MVVMSignInCoordinatorTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVVMSignInCoordinatorTests: XCTestCase {

    func testCoordinator_whenStart_thenVCIsNavigationController() {
        let navigationVC = UINavigationController()
        let coordinator = MVVMSignInCoordinator()
        coordinator.start(in: navigationVC)

        guard let VC = coordinator.VC else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(VC is MVVMSignInViewController)
    }
}
