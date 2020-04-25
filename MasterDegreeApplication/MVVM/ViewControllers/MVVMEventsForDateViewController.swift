//
//  MVVMEventsForDateViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 25/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVVMEventsForDateViewController: UIViewController {
    private let table = UITableView(frame: .zero, style: .grouped)
    private let viewModel: EventsForDateViewModel
    private weak var delegate: EventsForDateViewControllerDelegate?
    private let bag = DisposeBag()

    init(viewModel: EventsForDateViewModel, delegate: EventsForDateViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        [table].addTo(view)

        setupLayouts()
        setupStyles()
        setupActions()
        setupTable()
        bindViewModelToView()
    }
}

// MARK: - Setup UI
private extension MVVMEventsForDateViewController {
    func setupLayouts() {
        table.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 200, left: 50, bottom: 200, right: 50))
    }

    func setupStyles() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        table.backgroundColor = .white
        table.layer.cornerRadius = 20
    }
}

// MARK: - Private layer
private extension MVVMEventsForDateViewController {
    func setupTable() {
        table.register(MVVMEventCell.self, forCellReuseIdentifier: MVVMEventCell.identifier)
        table.dataSource = self
        table.delegate = self
    }

    func bindViewModelToView() {
        let input = EventsForDateViewModel.Input()

        _ = viewModel.transform(input: input)
    }
}

// MARK: - Actions
private extension MVVMEventsForDateViewController {
    func setupActions() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }

    @objc func didTapView() {
        delegate?.eventsForDateDidTapBack()
    }
}

extension MVVMEventsForDateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfViewModels
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MVVMEventCell.identifier, for: indexPath)
        if let eventCell = cell as? MVVMEventCell, let VM = viewModel.getViewModel(atIndex: indexPath.item) {
            eventCell.setup(withViewModel: VM)
        }
        return cell
    }
}
