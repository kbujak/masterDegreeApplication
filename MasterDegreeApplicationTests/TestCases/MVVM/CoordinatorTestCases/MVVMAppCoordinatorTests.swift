//
//  MVVMAppCoordinatorTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVVMAppCoordinatorTests: XCTestCase {

    func testCoordinator_whenInit_thenIdIsInitialised() {
        let id = UUID().uuidString
        let coordinatorId = CoordinatorIdentifier(id: id)
        let coordinator = MVVMAppCoordinator(context: ContextBuilder().build(), id: coordinatorId)

        XCTAssertEqual(id, coordinator.id.id)
    }

    func testCoordinator_whenInit_thenChildrenIsEmpty() {
        let coordinator = MVVMAppCoordinator(context: ContextBuilder().build())

        XCTAssertEqual(coordinator.children.count, 0)
    }

    func testCoordinator_whenInit_thenVCIsNil() {
        let coordinator = MVVMAppCoordinator(context: ContextBuilder().build())

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
        XCTAssert(childCoordinator is MVVMSignInCoordinator)
    }

    func teststart_whenKeychainDoesContainUserId_thenContainsSignInCoordinator() {
        let keychainMock = KeychainProviderMock()
        keychainMock.userId = "testId"
        let context = ContextBuilder()
            .with(keychainProvider: keychainMock)
            .build()
        let coordinator = MVVMAppCoordinator(context: context)
        let window = UIWindow(frame: UIScreen.main.bounds)

        coordinator.start(in: window)

        guard
            let childCoordinator = coordinator.children.values.first
        else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(childCoordinator is MVVMMainTabbarCoordinator)
    }
}

private extension MVVMAppCoordinatorTests {
    func createCoordinatorThenStart() -> AppCoordinator {
        let coordinator = MVVMAppCoordinator(context: ContextBuilder().build())
        let window = UIWindow(frame: UIScreen.main.bounds)
        coordinator.start(in: window)
        return coordinator
    }
}
