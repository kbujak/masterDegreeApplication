//
//  ProfileViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ProfileViewModel: ViewModel {
    private let user = BehaviorRelay<User?>(value: nil)
    private let logoutSubject = PublishSubject<Void>()
    private let context: Context
    private let bag = DisposeBag()

    init(context: Context) {
        self.context = context
    }

    func transform(input: ProfileViewModel.Input) -> ProfileViewModel.Output {
        user.accept(context.userDataCache.user)

        input.logOutTrigger.drive(
            onNext: { [weak self] in
                self?.context.userDataCache.clear()
                self?.context.keychainProvider.clear()
                self?.logoutSubject.onNext(())
            }
        )
        .disposed(by: bag)

        return Output(
            name: user.asDriver().filter { $0 != nil }.map { $0?.username ?? "" },
            logoutTrigger: logoutSubject.asDriver(onErrorRecover: { _ in Driver.never() })
        )
    }

    struct Input {
        let logOutTrigger: Driver<Void>
    }

    struct Output {
        let name: Driver<String>
        let logoutTrigger: Driver<Void>
    }
}
