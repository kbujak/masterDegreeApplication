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
    let context: Context

    required init(context: Context, id: CoordinatorIdentifier = CoordinatorIdentifier()) {
        self.context = context
        self.id = id
    }

    func start(in window: UIWindow) {
        fatalError("Start not implemented")
    }
}
