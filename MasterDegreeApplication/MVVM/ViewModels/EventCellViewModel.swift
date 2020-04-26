//
//  EventCellViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 25/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EventCellViewModel {
    var author: Driver<String> { get }
    var place: Driver<String> { get }
    var time: Driver<String> { get }
    var name: Driver<String> { get }
}

class EventCellViewModelImpl: EventCellViewModel {
    private let context: Context
    private let event: CalendarEvent
    private let authorRelay = BehaviorRelay<User?>(value: nil)
    private let placeRelay = BehaviorRelay<String>(value: "")
    private let timeRelay = BehaviorRelay<String>(value: "")
    private let nameRelay = BehaviorRelay<String>(value: "")
    private let bag = DisposeBag()

    var author: Driver<String> {
        return authorRelay.asDriver().map { $0?.username ?? ""}
    }
    var place: Driver<String> {
        return placeRelay.asDriver()
    }
    var time: Driver<String> {
        return timeRelay.asDriver()
    }
    var name: Driver<String> {
        return nameRelay.asDriver()
    }

    init(context: Context, event: CalendarEvent) {
        self.context = context
        self.event = event

        context.realmProvider.fetchUser(withId: event.ownerId).bind(to: authorRelay).disposed(by: bag)

        placeRelay.accept(event.place)

        timeRelay.accept(String(format: "%d:%02d,", event.hours, event.minutes))

        nameRelay.accept(event.name)
    }
}
