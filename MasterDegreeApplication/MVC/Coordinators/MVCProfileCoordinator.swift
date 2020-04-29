//
//  MVCProfileCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVCProfileCoordinator: CompoundCoordinator {
    var VC: UINavigationController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]
    let context: Context
    private weak var delegate: ProfileCoordinatorDelegate?

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in controller: UITabBarController, delegate: ProfileCoordinatorDelegate? = nil) {
        let VC = MVCProfileViewController(context: context, delegate: self)

        let navigationVC = UINavigationController(rootViewController: VC)
        navigationVC.isNavigationBarHidden = true
        self.VC = navigationVC
        navigationVC.tabBarItem.title = L10n.ProfileViewController.tabBarItem
        navigationVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appPurple],
                                                       for: .normal)

        self.delegate = delegate

        controller.addChild(navigationVC)
    }
}

// MARK: - ProfileViewControllerDelegate
extension MVCProfileCoordinator: ProfileViewControllerDelegate {
    func didLogOut() {
        delegate?.didLogOut()
    }
}
