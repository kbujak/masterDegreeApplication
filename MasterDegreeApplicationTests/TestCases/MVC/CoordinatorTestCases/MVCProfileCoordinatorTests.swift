//
//  MVCProfileCoordinatorTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
import UIKit
@testable import MasterDegreeApplication

class MVCProfileCoordinatorTests: XCTestCase {

    func testCoordinator_whenStart_thenRootIsTabbarController() {
        let coordinator = createCoordinatorAndStart()

        guard let VC = coordinator.VC else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(VC is UINavigationController)
    }

    private func createCoordinatorAndStart() -> MVCProfileCoordinator {
        let VC = UITabBarController()
        let coordinator = MVCProfileCoordinator(context: ContextBuilder().build())
        coordinator.start(in: VC)
        return coordinator
    }
}
