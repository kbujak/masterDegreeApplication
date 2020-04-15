//
//  MVCCalendarCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class MVCCalendarCoordinator: CompoundCoordinator {
    var VC: UINavigationController?
    var id: CoordinatorIdentifier
    var children: [CoordinatorIdentifier: Coordinator] = [:]
    let context: Context

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in controller: UITabBarController) {
        let VC = MVCCalendarViewController(context: context, delegate: self)

        let navigationVC = UINavigationController(rootViewController: VC)
        navigationVC.isNavigationBarHidden = true
        self.VC = navigationVC

        controller.addChild(navigationVC)
    }

    private func startCreateEventViewController() {
            guard let navigationVC = self.VC else { fatalError("Navigation controller not initialised") }
            let VC = MVCCreateEventViewController(context: context, delegate: self)
            VC.modalPresentationStyle = .fullScreen
            navigationVC.present(VC, animated: true, completion: nil)
        }
}

// MARK: - CalendarViewControllerDelegate
extension MVCCalendarCoordinator: CalendarViewControllerDelegate {
    func didTapCreate() {
        startCreateEventViewController()
    }
}

// MARK: - CreateEventViewControllerDelegate
extension MVCCalendarCoordinator: CreateEventViewControllerDelegate {
    func didTapBack() {
        VC?.dismiss(animated: true, completion: nil)
    }
}
