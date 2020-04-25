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

    private let authorLabel = UILabel()
    private let timeLabel = UILabel()
    private let placeLabel = UILabel()
    private let nameLabel = UILabel()

    private var viewModel: EventCellViewModel?
    private var bag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [authorLabel, timeLabel, placeLabel, nameLabel].addTo(self)

        setupLayouts()
        setupStyles()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        self.viewModel = nil
        self.bag = DisposeBag()
        super.prepareForReuse()
    }

    func setup(withViewModel viewModel: EventCellViewModel) {
        self.viewModel = viewModel
        bindViewModelToView()
    }
}

private extension MVVMEventCell {
    func setupLayouts() {
        authorLabel.autoPinEdge(.left, to: .left, of: self)
        authorLabel.autoPinEdge(.top, to: .top, of: self)
        timeLabel.autoPinEdge(.left, to: .left, of: self)
        timeLabel.autoPinEdge(.top, to: .top, of: authorLabel, withOffset: 20)
        placeLabel.autoPinEdge(.left, to: .right, of: timeLabel, withOffset: 5)
        placeLabel.autoPinEdge(.top, to: .top, of: authorLabel, withOffset: 20)
        nameLabel.autoPinEdge(.left, to: .right, of: placeLabel, withOffset: 15)
        nameLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 10)
    }

    func setupStyles() {
        backgroundColor = .blue
    }

    func bindViewModelToView() {
        guard let viewModel = self.viewModel else { return }
        viewModel.author.drive(authorLabel.rx.text).disposed(by: bag)
        viewModel.time.drive(timeLabel.rx.text).disposed(by: bag)
        viewModel.place.drive(placeLabel.rx.text).disposed(by: bag)
        viewModel.name.drive(nameLabel.rx.text).disposed(by: bag)
    }
}
