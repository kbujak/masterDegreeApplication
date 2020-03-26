//
//  MVVMMainTabbarCoordinatorTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class MVVMMainTabbarCoordinatorTests: XCTestCase {

    func testCoordinator_whenStart_thenRootIsTabbarController() {
        let coordinator = createCoordinatorAndStart()

        guard let VC = coordinator.VC else { XCTFail("Coordinator not initialised"); return }
        XCTAssert(VC is UITabBarController)
    }

    func testCoordinator_whenStart_thenHas3Children() {
        let coordinator = createCoordinatorAndStart()

        XCTAssertEqual(3, coordinator.children.values.count)
    }

    func testCoordinator_whenStart_containsUsersCoordinator() {
        let coordinator = createCoordinatorAndStart()

        let child = coordinator.children.values.first(where: { $0 is MVVMUsersCoordinator })
        XCTAssertNotNil(child)
    }

    func testCoordinator_whenStart_containsCalendarCoordinator() {
        let coordinator = createCoordinatorAndStart()

        let child = coordinator.children.values.first(where: { $0 is MVVMCalendarCoordinator })
        XCTAssertNotNil(child)
    }

    func testCoordinator_whenStart_containsProfileCoordinator() {
        let coordinator = createCoordinatorAndStart()

        let child = coordinator.children.values.first(where: { $0 is MVVMProfileCoordinator })
        XCTAssertNotNil(child)
    }

    private func createCoordinatorAndStart() -> MVVMMainTabbarCoordinator {
        let VC = UIViewController()
        let coordinator = MVVMMainTabbarCoordinator(context: ContextBuilder().build())
        coordinator.start(in: VC)
        return coordinator
    }
}
