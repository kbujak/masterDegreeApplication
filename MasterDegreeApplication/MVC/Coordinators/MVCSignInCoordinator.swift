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
    let context: Context

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in controller: UINavigationController) {
        let VC = MVCSignInViewController(context: context, delegate: self)
        self.VC = controller
        controller.pushViewController(VC, animated: true)
    }

    private func openSignUp() {
        guard let navigationVC = self.VC else { fatalError() }
        let controller = MVCSignUpViewController(context: context, delegate: self)
        navigationVC.pushViewController(controller, animated: true)
    }
}

// MARK: - SignInViewController
extension MVCSignInCoordinator: SignInViewControllerDelegate {
    func didSignInSuccessfully(withUser user: User) {
        print(user)
    }

    func didTapSignUp() {
        openSignUp()
    }
}

// MARK: - SignUpViewController
extension MVCSignInCoordinator: SignUpViewControllerDelegate {
    func didSignUpSuccessfully(_ user: User) {
        print(user)
    }

    func didTapBack() {
        VC?.popViewController(animated: true)
    }
}
