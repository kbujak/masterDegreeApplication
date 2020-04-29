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
        coordinator.start(in: navigationVC, delegate: self)
    }

    private func startMainTabbarCoordinator() {
        guard let navigationVC = self.VC else { fatalError("Navigation controller not initialised") }
        let coordinator: MVCMainTabbarCoordinator = createCoordinator()
        context.userDataCache.fetchData()
        coordinator.start(in: navigationVC, delegate: self)
    }

    private func restartAppState() {
        guard let navigationVC = self.VC else { fatalError("Navigation controller not initialised") }
        navigationVC.dismiss(animated: true, completion: nil)
        children = [:]
        startSignInCoordinator()
    }
}

// MARK: - MainTabBarCoordinatorDelegate
extension MVCAppCoordinator: MainTabBarCoordinatorDelegate {
    func didLogOutFromMainTabBarFlow() {
        restartAppState()
    }
}

// MARK: - SignInCoordinatorDelegate
extension MVCAppCoordinator: SignInCoordinatorDelegate {
    func didLogOutFromSignInFlow() {
        restartAppState()
    }
}
