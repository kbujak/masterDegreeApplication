//
//  MVVMProfileViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVVMProfileViewController: UIViewController {
    private let topContainer = UIView()
    private let nameLabel = UILabel()
    private let logoutButton = UIButton()
    private var gradientLayer: CAGradientLayer?

    private let viewModel: ProfileViewModel
    private let bag = DisposeBag()
    private weak var delegate: ProfileViewControllerDelegate?

    init(viewModel: ProfileViewModel, delegate: ProfileViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [topContainer, logoutButton].addTo(view)
        [nameLabel].addTo(topContainer)

        setupLayouts()
        setupStyles()
        bindViewModelToView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layer = gradientLayer {
            layer.removeFromSuperlayer()
        }
        self.gradientLayer = CAGradientLayer.createGradient(forView: topContainer)
    }
}

// MARK: - UI
private extension MVVMProfileViewController {
    func setupLayouts() {
        topContainer.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(), excludingEdge: .bottom)
        topContainer.autoSetDimension(.height, toSize: 250)

        nameLabel.autoPinEdge(.bottom, to: .bottom, of: topContainer, withOffset: -50)
        nameLabel.autoAlignAxis(.vertical, toSameAxisOf: topContainer)

        logoutButton.autoPinEdge(.top, to: .bottom, of: topContainer, withOffset: 50)
        logoutButton.autoAlignAxis(.vertical, toSameAxisOf: topContainer)
        logoutButton.autoSetDimension(.width, toSize: 100)
    }

    func setupStyles() {
        view.backgroundColor = .white

        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)

        logoutButton.setTitle(L10n.ProfileViewController.logOut, for: .normal)
        logoutButton.backgroundColor = .appPurple
        logoutButton.layer.cornerRadius = 6
    }
}

// MARK: - Private layer
private extension MVVMProfileViewController {
    func bindViewModelToView() {
        let input = ProfileViewModel.Input(
            logOutTrigger: logoutButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)

        output.name.drive(nameLabel.rx.text).disposed(by: bag)

        output.logoutTrigger.drive(
            onNext: { [weak self] in
                self?.delegate?.didLogOut()
            }
        )
    }
}
