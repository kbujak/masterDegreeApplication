//
//  SignInCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class SignInCoordinator: CompoundCoordinator {
    var VC: SignInViewController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]

    required init(id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.id = id
    }

    func start(in controller: UINavigationController) {
        let VM = SignInViewModel()
        let VC = SignInViewController(viewModel: VM)
        self.VC = VC
        controller.pushViewController(VC, animated: true)
    }
}
