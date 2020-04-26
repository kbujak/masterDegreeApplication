//
//  MVCEventsForDateViewController.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVCEventsForDateViewController: UIViewController {
    private let table = UITableView(frame: .zero, style: .grouped)
    private let context: Context
    private let events: [CalendarEvent]
    private var eventDTOs: [(User, CalendarEvent)] = []
    private weak var delegate: EventsForDateViewControllerDelegate?
    private let bag = DisposeBag()

    init(events: [CalendarEvent], context: Context, delegate: EventsForDateViewControllerDelegate? = nil) {
        self.context = context
        self.delegate = delegate
        self.events = events.sorted(by: <)
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
private extension MVCEventsForDateViewController {
    func setupLayouts() {
        table.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

    func setupStyles() {
        table.backgroundColor = .white
        table.layer.cornerRadius = 20
        table.separatorStyle = .none
    }
}

// MARK: - Private layer
private extension MVCEventsForDateViewController {
    func setupTable() {
        table.register(MVCEventCell.self, forCellReuseIdentifier: MVCEventCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 100
    }

    func bindViewModelToView() {
        Observable.from(events)
            .concatMap { [weak self] event -> Observable<(User, CalendarEvent)> in
                guard let `self` = self else { throw fatalError() }
                return self.context.realmProvider
                    .fetchUser(withId: event.ownerId)
                    .map { ($0, event) }
        }
        .toArray()
        .subscribe(
            onSuccess: { [weak self] eventDTOs in
                self?.eventDTOs = eventDTOs
                self?.table.reloadData()
            }
        )
        .disposed(by: bag)
    }
}

// MARK: - Actions
private extension MVCEventsForDateViewController {
    func setupActions() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }

    @objc func didTapView() {
        delegate?.eventsForDateDidTapBack()
    }
}

extension MVCEventsForDateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDTOs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MVCEventCell.identifier, for: indexPath)
        if let eventCell = cell as? MVCEventCell {
            let eventDTO = eventDTOs[indexPath.item]
            eventCell.setup(withEventDTO: eventDTO)
        }
        return cell
    }
}
