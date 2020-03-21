//
//  AppCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: CompoundCoordinator {
    var VC: UINavigationController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]

    required init(id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.id = id
    }

    func start(in window: UIWindow) {
        let navigationVC = UINavigationController()
        navigationVC.isNavigationBarHidden = true
        self.VC = navigationVC

        window.rootViewController = VC
        window.makeKeyAndVisible()

        startSignInCoordinator()
    }

    private func startSignInCoordinator() {
        guard let navigationVC = self.VC else { fatalError("Navigation controller not initialised") }
        let coordinator: SignInCoordinator = createCoordinator()
        coordinator.start(in: navigationVC)
    }
}
