//
//  MVVMSignInViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 19/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift
import RxCocoa

class MVVMSignInViewController: UIViewController {
    private let titleLabel = UILabel()
    private let usernameTextfield = BorderedTextField()
    private let passwordTextfield = BorderedTextField()
    private let signInButton = RoundedGrayButton()
    private let signUpButton = UIButton()

    private let viewModel: SignInViewModel
    private weak var delegate: SignInViewControllerDelegate?
    private let bag = DisposeBag()

    init(viewModel: SignInViewModel, delegate: SignInViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [titleLabel, usernameTextfield, passwordTextfield, signInButton, signUpButton].addTo(view)

        setupLayouts()
        setupStyles()
        bindViewModelToView()
    }
}

// MARK: - UI Setup
private extension MVVMSignInViewController {
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
        view.backgroundColor = UIColor.appPurple

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
private extension MVVMSignInViewController {
    func bindViewModelToView() {
        signUpButton.rx.tap.subscribe(onNext: { [weak self] in self?.delegate?.didTapSignUp() }).disposed(by: bag)

        let input = SignInViewModel.Input(
            username: usernameTextfield.rx.text.orEmpty.asDriver(),
            password: passwordTextfield.rx.text.orEmpty.asDriver(),
            signInTrigger: signInButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)

        output.user
            .subscribe(
                onNext: { [weak self] user in self?.delegate?.didSignInSuccessfully(withUser: user) },
                onError: { error in print(error) }
            )
            .disposed(by: bag)
    }
}
