//
//  AddUserViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddUserViewModel: ViewModel {
    private let context: Context
    private var users = BehaviorRelay<[User]>(value: [])
    private let bag = DisposeBag()

    init(context: Context) {
        self.context = context
    }

    func transform(input: AddUserViewModel.Input) -> AddUserViewModel.Output {
        input.search
            .subscribeOn(MainScheduler.asyncInstance)
            .flatMapLatest { [weak self] phrase -> Observable<[User]> in
                guard let `self` = self else { return Observable.error(AppErrors.unknownError) }
                return self.context.realmProvider
                    .fetchUser(withPhrase: phrase)
                    .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            }
            .bind(to: users)
            .disposed(by: bag)

        input.addUserTrigger
            .drive(onNext: { [weak self] index in self?.inviteUser(atIndex: index) })
            .disposed(by: bag)

        return Output(
            users: users.asObservable()
        )
    }

    func isFriend(_ user: User) -> Bool {
        guard let logedInUser = context.userDataCache.user else { return false }
        return logedInUser.friendIds.contains(user.id)
    }

    struct Input {
        let search: Observable<String>
        let addUserTrigger: Driver<Int>
    }

    struct Output {
        let users: Observable<[User]>
    }
}

private extension AddUserViewModel {
    func inviteUser(atIndex index: Int) {
        guard
            let currentUser = context.userDataCache.user,
            !currentUser.friendIds.contains(users.value[index].id)
        else { return }

        context.realmProvider.addFriend(withUserId: users.value[index].id, forUser: currentUser)
            .subscribe(
                onNext: { [weak self] user in
                    guard let `self` = self else { return }
                    self.context.userDataCache.update(user: user)
                    self.users.accept(self.users.value)
                }
            )
            .disposed(by: bag)
    }
}
