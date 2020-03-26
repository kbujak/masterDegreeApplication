//
//  MVVMProfileCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVVMProfileCoordinator: CompoundCoordinator {
    var VC: UINavigationController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]
    let context: Context

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in controller: UITabBarController) {
        let VM = ProfileViewModel(context: context)
        let VC = MVVMProfileViewController(viewModel: VM)

        let navigationVC = UINavigationController(rootViewController: VC)
        navigationVC.isNavigationBarHidden = true
        self.VC = navigationVC

        controller.addChild(navigationVC)
    }
}
