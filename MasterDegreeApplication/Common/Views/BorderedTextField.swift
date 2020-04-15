//
//  BorderedTextField.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class BorderedTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupLayouts()
        self.setupStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }

    private func setupLayouts() {
        self.autoSetDimension(.height, toSize: 35)
    }

    private func setupStyles() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 6
        self.textAlignment = .left
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
}
