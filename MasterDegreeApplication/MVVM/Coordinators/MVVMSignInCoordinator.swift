//
//  MVVMSignInCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVVMSignInCoordinator: CompoundCoordinator {
    var VC: UINavigationController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]

    required init(id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.id = id
    }

    func start(in controller: UINavigationController) {
        let VM = SignInViewModel()
        let VC = MVVMSignInViewController(viewModel: VM, delegate: self)
        self.VC = controller
        controller.pushViewController(VC, animated: true)
    }

    private func openSignUp() {
        guard let navigationVC = self.VC else { fatalError() }
        let viewModel = SignUpViewModel()
        let controller = MVVMSignUpViewController(viewModel: viewModel, delegate: self)
        navigationVC.pushViewController(controller, animated: true)
    }
}

// MARK: - SignInViewController
extension MVVMSignInCoordinator: SignInViewControllerDelegate {
    func didTapSignUp() {
        openSignUp()
    }
}

// MARK: - SignUpViewController
extension MVVMSignInCoordinator: SignUpViewControllerDelegate {
    func didTapBack() {
        VC?.popViewController(animated: true)
    }
}
