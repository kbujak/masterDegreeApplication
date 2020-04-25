//
//  EventsForDateViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 25/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EventsForDateViewModel: ViewModel {
    private let bag = DisposeBag()
    private let context: Context
    private var viewModels: [EventCellViewModel] = []

    var numberOfViewModels: Int {
        return viewModels.count
    }

    init(events: [CalendarEvent], context: Context) {
        self.viewModels = events.sorted(by: <).map { EventCellViewModelImpl(context: context, event: $0) }
        self.context = context
    }

    func transform(input: EventsForDateViewModel.Input) -> EventsForDateViewModel.Output {
        return Output()
    }

    func getViewModel(atIndex index: Int) -> EventCellViewModel? {
        guard index < viewModels.count else { return nil }
        return viewModels[index]
    }

    struct Input {}

    struct Output {}
}
