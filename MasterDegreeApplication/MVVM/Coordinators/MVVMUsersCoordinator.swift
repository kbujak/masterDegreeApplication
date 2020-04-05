//
//  MVVMUsersCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVVMUsersCoordinator: CompoundCoordinator {
    var VC: UINavigationController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]
    let context: Context

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in controller: UITabBarController) {
        let VM = UsersViewModel(context: context)
        let VC = MVVMUsersViewController(viewModel: VM, delegate: self)

        let navigationVC = UINavigationController(rootViewController: VC)
        navigationVC.isNavigationBarHidden = true
        self.VC = navigationVC
        navigationVC.tabBarItem.title = L10n.UsersViewController.tabBarItem
        navigationVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.mainColor],
                                                       for: .normal)

        controller.addChild(navigationVC)
    }

    private func createAddUsersViewController() {
        guard let navigationVC = self.VC else { fatalError("Navigation controller not initialised") }
        let VM = AddUserViewModel(context: context)
        let VC = MVVMAddUserViewController(viewModel: VM, delegate: self)
        navigationVC.pushViewController(VC, animated: true)
    }
}

// MARK: - UsersViewControllerDelegate
extension MVVMUsersCoordinator: UsersViewControllerDelegate {
    func didTapInvite() {
        createAddUsersViewController()
    }
}

// MARK: - AddUserViewControllerDelegate
extension MVVMUsersCoordinator: AddUserViewControllerDelegate {
    func didTapBack() {
        VC?.popViewController(animated: true)
    }
}
