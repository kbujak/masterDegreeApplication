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
    var VC: UINavigationController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]

    required init(id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.id = id
    }

    func start(in controller: UINavigationController) {
        let VC = MVCSignInViewController(delegate: self)
        self.VC = controller
        controller.pushViewController(VC, animated: true)
    }

    private func openSignUp() {
        guard let navigationVC = self.VC else { fatalError() }
        let controller = MVCSignUpViewController(delegate: self)
        navigationVC.pushViewController(controller, animated: true)
    }
}

// MARK: - SignInViewController
extension MVCSignInCoordinator: SignInViewControllerDelegate {
    func didTapSignUp() {
        openSignUp()
    }
}

// MARK: - SignUpViewController
extension MVCSignInCoordinator: SignUpViewControllerDelegate {
    func didTapBack() {
        VC?.popViewController(animated: true)
    }
}
