//
//  MVCSignInViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 22/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift

class MVCSignInViewController: UIViewController {
    private let titleLabel = UILabel()
    private let usernameTextfield = BorderedTextField()
    private let passwordTextfield = BorderedTextField()
    private let signInButton = RoundedGrayButton()
    private let signUpButton = UIButton()
    private weak var delegate: SignInViewControllerDelegate?
    private let bag = DisposeBag()
    private let context: Context

    init(context: Context, delegate: SignInViewControllerDelegate? = nil) {
        self.delegate = delegate
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        [titleLabel, usernameTextfield, passwordTextfield, signInButton, signUpButton].addTo(view)

        setupLayouts()
        setupStyles()
        setupActions()
    }
}

// MARK: - Setup UI
private extension MVCSignInViewController {
    func setupLayouts() {
        titleLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 200, left: 20, bottom: 0, right: 20),
                                                   excludingEdge: .bottom)

        usernameTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 250, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        passwordTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 305, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        signInButton.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 370, left: 100, bottom: 0, right: 100),
            excludingEdge: .bottom
        )

        signUpButton.autoPinEdge(.top, to: .bottom, of: signInButton, withOffset: 3)
        signUpButton.autoAlignAxis(.vertical, toSameAxisOf: view)
    }

    func setupStyles() {
        view.backgroundColor = UIColor.mainColor

        titleLabel.text = L10n.SignInViewController.title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)

        usernameTextfield.placeholder = L10n.Common.username

        passwordTextfield.placeholder = L10n.Common.password
        passwordTextfield.isSecureTextEntry = true

        signInButton.setTitle(L10n.SignInViewController.signIn, for: .normal)

        signUpButton.setAttributedTitle(
            NSAttributedString(string: L10n.SignInViewController.signUp,
                               attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]),
            for: .normal
        )
    }
}

// MARK: - Private layer
private extension MVCSignInViewController {
    func setupActions() {
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.delegate?.didTapSignUp() })
            .disposed(by: bag)

        signInButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.fetchUser() })
            .disposed(by: bag)
    }

    func fetchUser() {
        guard
            let username = usernameTextfield.text,
            let password = passwordTextfield.text,
            !username.isEmpty && username != "",
            !password.isEmpty && password != ""
        else { return }

        context.realmProvider.fetchUser(withUsername: username, password: password)
            .subscribe(
                onNext: { [weak self] user in
                    guard let user = user else { return }
                    self?.context.keychainProvider.userId = user.id
                    self?.delegate?.didSignInSuccessfully(withUser: user)
                },
                onError: { error in print(error) }
            )
            .disposed(by: bag)
    }
}
