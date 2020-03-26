//
//  MVCAppCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVCAppCoordinator: AppCoordinator {

    override func start(in window: UIWindow) {
        let navigationVC = UINavigationController()
        navigationVC.isNavigationBarHidden = true
        self.VC = navigationVC

        window.rootViewController = VC
        window.makeKeyAndVisible()

        context.keychainProvider.userId == nil ? startSignInCoordinator() : startMainTabbarCoordinator()
    }

    private func startSignInCoordinator() {
        guard let navigationVC = self.VC else { fatalError("Navigation controller not initialised") }
        let coordinator: MVCSignInCoordinator = createCoordinator()
        coordinator.start(in: navigationVC)
    }

    private func startMainTabbarCoordinator() {
        guard let navigationVC = self.VC else { fatalError("Navigation controller not initialised") }
        let coordinator: MVCMainTabbarCoordinator = createCoordinator()
        coordinator.start(in: navigationVC)
    }
}
