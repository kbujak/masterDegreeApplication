//
//  MVCEventCell.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MVCEventCell: UITableViewCell {
    static let identifier = "MVCEventCell"

    private let containerView = UIView()
    private let authorLabel = UILabel()
    private let timeLabel = UILabel()
    private let placeLabel = UILabel()
    private let nameLabel = UILabel()
    private var gradientLayer: CAGradientLayer?

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
        self.bag = DisposeBag()
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let layer = self.gradientLayer {
            layer.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.frame
        gradientLayer.colors = [UIColor.appPurple.cgColor, UIColor.appBlue.cgColor]
        gradientLayer.locations = [0.0, 0.95]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        containerView.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }

    func setup(withEventDTO eventDTO: (User, CalendarEvent)) {
        authorLabel.text = eventDTO.0.username
        timeLabel.text = String(format: "%d:%02d,", eventDTO.1.hours, eventDTO.1.minutes)
        placeLabel.text = eventDTO.1.place
        nameLabel.text = eventDTO.1.name
    }
}

private extension MVCEventCell {
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
}

