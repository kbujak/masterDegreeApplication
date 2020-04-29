//
//  MVCMainTabbarCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVCMainTabbarCoordinator: CompoundCoordinator {
    var VC: UITabBarController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]
    let context: Context
    private weak var delegate: MainTabBarCoordinatorDelegate?

    private var parentVC: UIViewController?

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in controller: UIViewController, delegate: MainTabBarCoordinatorDelegate? = nil) {
        self.parentVC = controller

        let VC = UITabBarController()
        VC.modalPresentationStyle = .fullScreen
        self.VC = VC

        startUsersCoordinator()
        startCalendarCoordinator()
        startProfileCoordinator()

        self.delegate = delegate

        controller.present(VC, animated: true, completion: nil)
    }

    private func startUsersCoordinator() {
        guard let VC = self.VC else { fatalError() }
        let coordinator: MVCUsersCoordinator = createCoordinator()
        coordinator.start(in: VC)
    }

    private func startCalendarCoordinator() {
        guard let VC = self.VC else { fatalError() }
        let coordinator: MVCCalendarCoordinator = createCoordinator()
        coordinator.start(in: VC)
    }

    private func startProfileCoordinator() {
        guard let VC = self.VC else { fatalError() }
        let coordinator: MVCProfileCoordinator = createCoordinator()
        coordinator.start(in: VC, delegate: self)
    }
}

// MARK: - ProfileCoordinatorDelegate
extension MVCMainTabbarCoordinator: ProfileCoordinatorDelegate {
    func didLogOut() {
        children = [:]
        delegate?.didLogOutFromMainTabBarFlow()
    }
}
