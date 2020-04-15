//
//  MVVMCalendarCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVVMCalendarCoordinator: CompoundCoordinator {
    var VC: UINavigationController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]
    let context: Context

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in controller: UITabBarController) {
        let VM = CalendarViewModel(context: context)
        let VC = MVVMCalendarViewController(viewModel: VM, delegate: self)

        let navigationVC = UINavigationController(rootViewController: VC)
        navigationVC.isNavigationBarHidden = true
        self.VC = navigationVC

        controller.addChild(navigationVC)
    }

    private func startCreateEventViewController() {
        guard let navigationVC = self.VC else { fatalError("Navigation controller not initialised") }
        let VM = CreateEventViewModel(context: context)
        let VC = MVVMCreateEventViewController(viewModel: VM, delegate: self)
        VC.modalPresentationStyle = .fullScreen
        navigationVC.present(VC, animated: true, completion: nil)
    }
}

// MARK: - CalendarViewControllerDelegate
extension MVVMCalendarCoordinator: CalendarViewControllerDelegate {
    func didTapCreate() {
        startCreateEventViewController()
    }
}

// MARK: - CreateEventViewControllerDelegate
extension MVVMCalendarCoordinator: CreateEventViewControllerDelegate {
    func didTapBack() {
        VC?.dismiss(animated: true, completion: nil)
    }
}
