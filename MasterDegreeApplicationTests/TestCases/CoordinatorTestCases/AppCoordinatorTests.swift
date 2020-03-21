//
//  AppCoordinatorTest.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class AppCoordinatorTest: XCTestCase {

    func testAppCoordinator_whenInit_thenIdIsInitialised() {
        let id = UUID().uuidString
        let coordinatorId = CoordinatorIdentifier(id: id)
        let coordinator = AppCoordinator(id: coordinatorId)

        XCTAssertEqual(id, coordinator.id.id)
    }

    func testAppCoordinator_whenInit_thenChildrenIsEmpty() {
        let coordinator = AppCoordinator()

        XCTAssertEqual(coordinator.children.count, 0)
    }

    func testAppCoordinator_whenInit_thenVCIsNil() {
        let coordinator = AppCoordinator()

        XCTAssertNil(coordinator.VC)
    }

    func testAppCoordinator_whenStart_thenVCIsNotNil() {
        let coordinator = createCoordinatorThenStart()

        XCTAssertNotNil(coordinator.VC)
    }

    func testAppCoordinator_whenStart_thenVCIsNavigationController() {
        let coordinator = createCoordinatorThenStart()

        guard let VC = coordinator.VC else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(VC is UINavigationController)
    }
}

private extension AppCoordinatorTest {
    func createCoordinatorThenStart() -> AppCoordinator {
        let coordinator = AppCoordinator()
        let window = UIWindow(frame: UIScreen.main.bounds)
        coordinator.start(in: window)
        return coordinator
    }
}
