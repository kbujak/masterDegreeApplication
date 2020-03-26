//
//  SignUpViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModel {

    private let usernameRelay = BehaviorRelay<String>(value: "")
    private let passwordRelay = BehaviorRelay<String>(value: "")
    private let retypePasswordRelay = BehaviorRelay<String>(value: "")
    private let userSubject = PublishSubject<User>()
    private let bag = DisposeBag()
    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func transform(input: SignUpViewModel.Input) -> SignUpViewModel.Output {
        input.username.drive(usernameRelay).disposed(by: bag)
        input.password.drive(passwordRelay).disposed(by: bag)
        input.retypePassword.drive(retypePasswordRelay).disposed(by: bag)
        input.registerTrigger.drive(onNext: { [weak self] in self?.createUser() }).disposed(by: bag)
        return Output(user: userSubject.asObservable())
    }

    struct Input {
        let username: Driver<String>
        let password: Driver<String>
        let retypePassword: Driver<String>
        let registerTrigger: Driver<Void>
    }

    struct Output {
        let user: Observable<User>
    }

    private func createUser() {
        guard
            Validator.username(usernameRelay.value).validate(),
            Validator.password(passwordRelay.value).validate(),
            Validator.retypePassword(passwordRelay.value, retypePasswordRelay.value).validate()
        else { return }

        let user = User(username: usernameRelay.value, password: passwordRelay.value)

        context.realmProvider.createUser(withUser: user)
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { [weak self] user in self?.context.keychainProvider.userId = user.id })
            .bind(to: userSubject)
            .disposed(by: bag)
    }
}
