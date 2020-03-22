//
//  Array+UIView.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element == UIView {
    func addTo(_ view: UIView) {
        self.forEach { view.addSubview($0) }
    }

    func addTo(_ view: UIStackView) {
        self.forEach { view.addArrangedSubview($0) }
    }
}
