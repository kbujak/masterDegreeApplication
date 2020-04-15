//
//  CreateEventViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 13/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CreateEventViewModel: ViewModel {
    private var date: Date?
    private var hours: Int?
    private var minutes: Int?
    private var nameRelay = BehaviorRelay<String?>(value: nil)
    private var placeRelay = BehaviorRelay<String?>(value: nil)
    private var timeRelay = BehaviorRelay<String>(value: "")
    private let context: Context
    private let bag = DisposeBag()
    private let errorSubject = PublishSubject<Error>()

    init(context: Context) {
        self.context = context
    }

    func transform(input: CreateEventViewModel.Input) -> CreateEventViewModel.Output {
        input.date.share()
            .subscribe(
                onNext: { [weak self] date in self?.date = date },
                onError: { [weak self] error in self?.errorSubject.onNext(error) }
            )
            .disposed(by: bag)

        input.hour.share()
            .subscribe(
                onNext: { [weak self] date in
                    let calendar = Calendar.current
                    let comp = calendar.dateComponents([.hour, .minute], from: date)
                    let hours = comp.hour
                    let minutes = comp.minute
                    self?.hours = hours
                    self?.minutes = minutes
                    self?.timeRelay.accept("\(hours ?? 0):\(minutes ?? 0)")
                },
                onError: { [weak self] error in self?.errorSubject.onNext(error) }
            )
            .disposed(by: bag)

        input.name.bind(to: nameRelay).disposed(by: bag)

        input.place.bind(to: placeRelay).disposed(by: bag)

        input.submitTrigger.drive(onNext: { [weak self] in self?.submit() }).disposed(by: bag)

        let dateString = input.date.share().map { date -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
        .asDriver(onErrorRecover: { _ in Driver.never() })

        return Output(
            dateString: dateString,
            timeString: timeRelay.asDriver(),
            error: errorSubject.asObservable()
        )
    }

    struct Input {
        let date: Observable<Date>
        let hour: Observable<Date>
        let name: Observable<String?>
        let place: Observable<String?>
        let submitTrigger: Driver<Void>
    }

    struct Output {
        let dateString: Driver<String>
        let timeString: Driver<String>
        let error: Observable<Error>
    }
}

private extension CreateEventViewModel {
    func submit() {
        guard
            let date = date, let hours = hours, let minutes = minutes, let name = nameRelay.value, let place = placeRelay.value,
            !name.isEmpty, name != "",
            !place.isEmpty, place != "",
            let user = context.userDataCache.user
        else { return}

        let event = CalendarEvent(ownerId: user.id, name: name, place: place, hours: hours, minutes: minutes, date: date)
        print(event)
    }
}
