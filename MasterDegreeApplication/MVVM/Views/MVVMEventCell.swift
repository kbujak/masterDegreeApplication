//
//  MVVMEventCell.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 25/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MVVMEventCell: UITableViewCell {
    static let identifier = "MVVMEventCell"

    private let containerView = UIView()
    private let authorLabel = UILabel()
    private let timeLabel = UILabel()
    private let placeLabel = UILabel()
    private let nameLabel = UILabel()
    private var gradientLayer: CAGradientLayer?

    private var viewModel: EventCellViewModel?
    private var bag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        [authorLabel, timeLabel, placeLabel, nameLabel].addTo(containerView)

        setupLayouts()
        setupStyles()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        self.viewModel = nil
        self.bag = DisposeBag()
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let layer = gradientLayer {
            layer.removeFromSuperlayer()
        }
        self.gradientLayer = CAGradientLayer.createGradient(forView: containerView)
    }

    func setup(withViewModel viewModel: EventCellViewModel) {
        self.viewModel = viewModel
        bindViewModelToView()
    }
}

private extension MVVMEventCell {
    func setupLayouts() {
        containerView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))

        authorLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: 10)
        authorLabel.autoPinEdge(.top, to: .top, of: containerView, withOffset: 20)

        timeLabel.autoPinEdge(.left, to: .left, of: authorLabel)
        timeLabel.autoPinEdge(.top, to: .bottom, of: authorLabel, withOffset: 2)

        placeLabel.autoPinEdge(.left, to: .right, of: timeLabel, withOffset: 5)
        placeLabel.autoPinEdge(.top, to: .bottom, of: authorLabel, withOffset: 2)

        nameLabel.autoPinEdge(.left, to: .left, of: containerView, withOffset: 150)
        nameLabel.autoAlignAxis(.horizontal, toSameAxisOf: containerView)
    }

    func setupStyles() {
        authorLabel.textColor = .white
        authorLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)

        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)

        placeLabel.textColor = .white
        placeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)

        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        nameLabel.numberOfLines = 0
    }

    func bindViewModelToView() {
        guard let viewModel = self.viewModel else { return }
        viewModel.author.drive(authorLabel.rx.text).disposed(by: bag)
        viewModel.time.drive(timeLabel.rx.text).disposed(by: bag)
        viewModel.place.drive(placeLabel.rx.text).disposed(by: bag)
        viewModel.name.drive(nameLabel.rx.text).disposed(by: bag)
    }
}
