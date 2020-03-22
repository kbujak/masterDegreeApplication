//
//  AppCoordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: CompoundCoordinator {
    var children = [CoordinatorIdentifier: Coordinator]()
    var VC: UINavigationController?
    var id: CoordinatorIdentifier

    required init(id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.id = id
    }

    func start(in window: UIWindow) {
        fatalError("Start not implemented")
    }
}
