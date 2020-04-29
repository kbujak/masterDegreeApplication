//
//  CAGradientLayer+Factory.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 29/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    static func createGradient(forView view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = [UIColor.appPurple.cgColor, UIColor.appBlue.cgColor]
        gradientLayer.locations = [0.0, 0.95]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}
