//
//  Coordinator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var id: CoordinatorIdentifier { get }
    var context: Context { get }

    init(context: Context, id: CoordinatorIdentifier)
}

protocol CompoundCoordinator: Coordinator {
    associatedtype Controller: UIViewController

    var children: [CoordinatorIdentifier: Coordinator] { get set }
    var VC: Controller? { get set }
}

extension CompoundCoordinator {
    func createCoordinator<Child: Coordinator>() -> Child {
        let coordinator = Child(context: self.context, id: CoordinatorIdentifier())
        children[coordinator.id] = coordinator
        return coordinator
    }

    func destroy<Child: Coordinator>(source: Child) {
        children.removeValue(forKey: source.id)
    }
}

struct CoordinatorIdentifier: Hashable, CustomStringConvertible {
    var id: String

    init(id: String = UUID().uuidString) {
        self.id = id
    }

    var description: String { return id }
}
