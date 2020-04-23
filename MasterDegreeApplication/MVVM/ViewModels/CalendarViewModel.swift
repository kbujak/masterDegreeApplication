//
//  CalendarViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel: ViewModel {
    private let context: Context
    private let bag = DisposeBag()
    private let events = BehaviorRelay<[CalendarEvent]>(value: [])

    init(context: Context) {
        self.context = context
    }

    func transform(input: CalendarViewModel.Input) -> CalendarViewModel.Output {
        if let user = context.userDataCache.user {
            let accumulatedIds = [user.id] + user.friendIds
            context.realmProvider.fetchEvents(forUserIds: accumulatedIds).bind(to: events).disposed(by: bag)
        }

        return Output(
            events: events.asObservable()
        )
    }

    func getEvents(fromDate date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let filteredEvents = events.value.filter { event -> Bool in
            let eventComponents = calendar.dateComponents([.year, .month, .day], from: event.date)
            return eventComponents == dateComponents
        }
        return filteredEvents
    }

    struct Input {

    }

    struct Output {
        let events: Observable<[CalendarEvent]>
    }
}
