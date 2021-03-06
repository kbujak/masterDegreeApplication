//
//  UsersViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class UsersViewModel: ViewModel {
    private let context: Context
    private let bag = DisposeBag()
    private let friendsRelay = BehaviorRelay<[User]>(value: [])

    init(context: Context) {
        self.context = context
    }

    func transform(input: UsersViewModel.Input) -> UsersViewModel.Output {
        Observable.combineLatest(Observable.just(()), context.userDataCache.userUpdated)
            .observeOn(MainScheduler.asyncInstance)
            .flatMap { [weak self] _ -> Observable<[User]> in
                guard
                    let `self` = self,
                    let currentUser = self.context.userDataCache.user
                else { return Observable.empty() }

                return self.context.realmProvider.fetchFriends(forUser: currentUser)
                    .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            }
            .bind(to: friendsRelay)
            .disposed(by: bag)

        return Output(
            friends: friendsRelay.asObservable()
        )
    }

    struct Input {}

    struct Output {
        let friends: Observable<[User]>
    }
}
