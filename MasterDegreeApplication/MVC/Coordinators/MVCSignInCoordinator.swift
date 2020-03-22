//
//  MVCSignInCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVCSignInCoordinator: CompoundCoordinator {
    var VC: MVCSignInViewController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]

    required init(id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.id = id
    }

    func start(in controller: UINavigationController) {
        let VC = MVCSignInViewController()
        self.VC = VC
        controller.pushViewController(VC, animated: true)
    }
}
