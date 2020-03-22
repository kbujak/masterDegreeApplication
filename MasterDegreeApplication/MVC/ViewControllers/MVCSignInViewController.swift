//
//  MVCSignInViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import PureLayout

class MVCSignInViewController: UIViewController {
    private let titleLabel = UILabel()
    private let usernameTextfield = UITextField()
    private let passwordTextfield = UITextField()
    private let signInButton = UIButton()
    private let signUpButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        [titleLabel, usernameTextfield, passwordTextfield, signInButton, signUpButton].addTo(view)

        setupLayouts()
        setupStyles()
    }
}

private extension MVCSignInViewController {
    func setupLayouts() {
        titleLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 200, left: 20, bottom: 0, right: 20),
                                                   excludingEdge: .bottom)

        usernameTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 250, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )
        usernameTextfield.autoSetDimension(.height, toSize: 35)

        passwordTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 305, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )
        passwordTextfield.autoSetDimension(.height, toSize: 35)

        signInButton.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 370, left: 100, bottom: 0, right: 100),
            excludingEdge: .bottom
        )
        signInButton.autoSetDimension(.height, toSize: 40)

        signUpButton.autoPinEdge(.top, to: .bottom, of: signInButton, withOffset: 3)
        signUpButton.autoAlignAxis(.vertical, toSameAxisOf: view)
    }

    func setupStyles() {
        view.backgroundColor = UIColor.mainColor

        titleLabel.text = L10n.SignInViewController.title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)

        usernameTextfield.placeholder = L10n.SignInViewController.username
        usernameTextfield.backgroundColor = .white
        usernameTextfield.layer.cornerRadius = 6
        usernameTextfield.textAlignment = .left
        usernameTextfield.layer.borderColor = UIColor.black.cgColor
        usernameTextfield.layer.borderWidth = 1

        passwordTextfield.placeholder = L10n.SignInViewController.password
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.backgroundColor = .white
        passwordTextfield.layer.cornerRadius = 6
        passwordTextfield.textAlignment = .left
        passwordTextfield.layer.borderColor = UIColor.black.cgColor
        passwordTextfield.layer.borderWidth = 1

        signInButton.backgroundColor = .lightGray
        signInButton.layer.cornerRadius = 6
        signInButton.layer.borderColor = UIColor.black.cgColor
        signInButton.layer.borderWidth = 1
        signInButton.setTitle(L10n.SignInViewController.signIn, for: .normal)

        signUpButton.setAttributedTitle(
            NSAttributedString(string: L10n.SignInViewController.signUp,
                               attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]),
            for: .normal
        )
    }
}
