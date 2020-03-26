//
//  MVCSignUpViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import RxSwift
import RxCocoa

class MVCSignUpViewController: UIViewController {

    private let backButton = UIButton(type: .close)
    private let titleLabel = UILabel()
    private let usernameTextfield = SignInTextfield()
    private let passwordTextfield = SignInTextfield()
    private let retypePasswordTextfield = SignInTextfield()
    private let submitButton = SignInButton()

    private weak var delegate: SignUpViewControllerDelegate?
    private let bag = DisposeBag()
    private let context: Context

    init(context: Context, delegate: SignUpViewControllerDelegate? = nil) {
        self.delegate = delegate
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [backButton,
         titleLabel,
         usernameTextfield,
         passwordTextfield,
         retypePasswordTextfield,
         submitButton].addTo(view)

        setupLayouts()
        setupStyles()
        setupActions()
    }

}

// MARK: - Setup UI
private extension MVCSignUpViewController {
    private func setupLayouts() {
        backButton.autoPinEdge(.top, to: .top, of: view, withOffset: 50)
        backButton.autoPinEdge(.left, to: .left, of: view, withOffset: 30)

        titleLabel.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 200, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        usernameTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 250, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        passwordTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 305, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        retypePasswordTextfield.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 360, left: 20, bottom: 0, right: 20),
            excludingEdge: .bottom
        )

        submitButton.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 425, left: 100, bottom: 0, right: 100),
            excludingEdge: .bottom
        )
    }

    private func setupStyles() {
        view.backgroundColor = .mainColor

        titleLabel.text = L10n.SignUpViewController.title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)

        usernameTextfield.placeholder = L10n.Common.username

        passwordTextfield.placeholder = L10n.Common.password
        passwordTextfield.isSecureTextEntry = true

        retypePasswordTextfield.placeholder = L10n.SignUpViewController.retypePassword
        retypePasswordTextfield.isSecureTextEntry = true

        submitButton.setTitle(L10n.SignUpViewController.signUp, for: .normal)
    }
}

// MARK: - Private layer
private extension MVCSignUpViewController {
    func setupActions() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.delegate?.didTapBack() })
            .disposed(by: bag)

        submitButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.createUser() })
            .disposed(by: bag)
    }

    func createUser() {
        guard
            let username = usernameTextfield.text,
            let password = passwordTextfield.text,
            let retypePassword = retypePasswordTextfield.text,
            Validator.username(username).validate(),
            Validator.password(password).validate(),
            Validator.retypePassword(password, retypePassword).validate()
        else { return }

        let user = User(username: username, password: password)
        context.realmProvider.createUser(withUser: user)
            .subscribe(
                onNext: { [weak self] user in
                    self?.context.keychainProvider.userId = user.id
                    self?.delegate?.didSignUpSuccessfully(user)
                },
                onError: { error in print(error) }
            )
            .disposed(by: bag)
        print(user)
    }
}
