//
//  UIViewController+UIWindow.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit

extension UIViewController {
    func mockInWindow(_ code: () -> Void) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self
        window.makeKeyAndVisible()
        code()
    }
}
