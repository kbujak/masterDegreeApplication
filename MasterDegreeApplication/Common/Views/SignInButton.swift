//
//  SignInButton.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit

class SignInButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupLayouts()
        self.setupStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyles() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }

    private func setupLayouts() {
        self.autoSetDimension(.height, toSize: 40)
    }
}
