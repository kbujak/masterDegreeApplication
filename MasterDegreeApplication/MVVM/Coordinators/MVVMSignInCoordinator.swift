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
    let context: Context
    private weak var delegate: SignInCoordinatorDelegate?

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in controller: UINavigationController, delegate: SignInCoordinatorDelegate? = nil) {
        let VM = SignInViewModel(context: context)
        let VC = MVVMSignInViewController(viewModel: VM, delegate: self)
        self.VC = controller

        self.delegate = delegate

        controller.pushViewController(VC, animated: true)
    }

    private func startMainTabbarCoordinator(withUser user: User) {
        guard let VC = self.VC else { fatalError() }
        context.userDataCache.update(user: user)
        let coordinator: MVVMMainTabbarCoordinator = createCoordinator()
        coordinator.start(in: VC, delegate: self)
    }

    private func openSignUp() {
        guard let navigationVC = self.VC else { fatalError() }
        let viewModel = SignUpViewModel(context: context)
        let controller = MVVMSignUpViewController(viewModel: viewModel, delegate: self)
        navigationVC.pushViewController(controller, animated: true)
    }
}

// MARK: - SignInViewController
extension MVVMSignInCoordinator: SignInViewControllerDelegate {
    func didTapSignUp() {
        openSignUp()
    }

    func didSignInSuccessfully(withUser user: User) {
        startMainTabbarCoordinator(withUser: user)
    }
}

// MARK: - SignUpViewController
extension MVVMSignInCoordinator: SignUpViewControllerDelegate {
    func didSignUpSuccessfully(_ user: User) {
        startMainTabbarCoordinator(withUser: user)
    }

    func didTapBack() {
        VC?.popViewController(animated: true)
    }
}

// MARK: - SignUpViewController
extension MVVMSignInCoordinator: MainTabBarCoordinatorDelegate {
    func didLogOutFromMainTabBarFlow() {
        delegate?.didLogOutFromSignInFlow()
    }
}
