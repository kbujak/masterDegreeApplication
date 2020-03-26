//
//  SignInViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel: ViewModel {
    private let usernameRelay = BehaviorRelay<String>(value: "")
    private let passwordRelay = BehaviorRelay<String>(value: "")
    private let bag = DisposeBag()
    private let userSubject = PublishSubject<User>()
    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func transform(input: SignInViewModel.Input) -> SignInViewModel.Output {
        input.username.drive(usernameRelay).disposed(by: bag)
        input.password.drive(passwordRelay).disposed(by: bag)
        input.signInTrigger.drive(onNext: { [weak self] in self?.fetchUser() }).disposed(by: bag)
        return Output(user: userSubject.asObservable())
    }

    struct Input {
        let username: Driver<String>
        let password: Driver<String>
        let signInTrigger: Driver<Void>
    }

    struct Output {
        let user: Observable<User>
    }

    private func fetchUser() {
        guard
            !usernameRelay.value.isEmpty,
            usernameRelay.value != "",
            !passwordRelay.value.isEmpty,
            passwordRelay.value != ""
        else { return }

        context.realmProvider.fetchUser(withUsername: usernameRelay.value, password: passwordRelay.value)
            .subscribe(
                onNext: { [weak self] user in
                    guard let user = user else { return }
                    self?.context.keychainProvider.userId = user.id
                    self?.userSubject.onNext(user)
                },
                onError: { error in print(error) }
            )
            .disposed(by: bag)
    }
}
