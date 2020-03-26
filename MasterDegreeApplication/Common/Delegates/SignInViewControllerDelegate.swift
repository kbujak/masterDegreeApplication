//
//  SignInViewControllerDelegate.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation

protocol SignInViewControllerDelegate: class {
    func didTapSignUp()
    func didSignInSuccessfully(withUser user: User)
}
