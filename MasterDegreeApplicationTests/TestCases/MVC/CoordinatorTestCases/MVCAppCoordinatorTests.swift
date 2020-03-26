//
//  MVCAppCoordinatorTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVCAppCoordinatorTests: XCTestCase {

    func testCoordinator_whenInit_thenIdIsInitialised() {
        let id = UUID().uuidString
        let coordinatorId = CoordinatorIdentifier(id: id)
        let coordinator = MVCAppCoordinator(context: ContextBuilder().build(), id: coordinatorId)

        XCTAssertEqual(id, coordinator.id.id)
    }

    func testCoordinator_whenInit_thenChildrenIsEmpty() {
        let coordinator = MVCAppCoordinator(context: ContextBuilder().build())

        XCTAssertEqual(coordinator.children.count, 0)
    }

    func testCoordinator_whenInit_thenVCIsNil() {
        let coordinator = MVCAppCoordinator(context: ContextBuilder().build())

        XCTAssertNil(coordinator.VC)
    }

    func testCoordinator_whenStart_thenVCIsNotNil() {
        let coordinator = createCoordinatorThenStart()

        XCTAssertNotNil(coordinator.VC)
    }

    func testCoordinator_whenStart_thenVCIsNavigationController() {
        let coordinator = createCoordinatorThenStart()

        guard let VC = coordinator.VC else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(VC is UINavigationController)
    }

    func teststart_whenKeychainDoesNotContainUserId_thenContainsSignInCoordinator() {
        let coordinator = createCoordinatorThenStart()

        guard
            let childCoordinator = coordinator.children.values.first
        else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(childCoordinator is MVCSignInCoordinator)
    }

    func teststart_whenKeychainDoesContainUserId_thenContainsSignInCoordinator() {
        let keychainMock = KeychainProviderMock()
        keychainMock.userId = "testId"
        let context = ContextBuilder()
            .with(keychainProvider: keychainMock)
            .build()
        let coordinator = MVCAppCoordinator(context: context)
        let window = UIWindow(frame: UIScreen.main.bounds)

        coordinator.start(in: window)

        guard
            let childCoordinator = coordinator.children.values.first
        else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(childCoordinator is MVCMainTabbarCoordinator)
    }
}

private extension MVCAppCoordinatorTests {
    func createCoordinatorThenStart() -> AppCoordinator {
        let coordinator = MVCAppCoordinator(context: ContextBuilder().build())
        let window = UIWindow(frame: UIScreen.main.bounds)
        coordinator.start(in: window)
        return coordinator
    }
}
