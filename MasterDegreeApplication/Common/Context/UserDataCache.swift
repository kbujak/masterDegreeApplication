//
//  UserDataCache.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 31/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserDataCache: class {
    var user: User? { get }
    var userUpdated: Observable<Void> { get }

    func fetchData()
    func update(user: User)
}

class UserDataCacheImpl: UserDataCache {
    private let userRelay = BehaviorRelay<User?>(value: nil)
    private let keychainProvider: KeychainProvider
    private let realmProvider: RealmProvider
    private let bag = DisposeBag()

    var user: User? {
        return userRelay.value
    }
    var userUpdated: Observable<Void> {
        return userRelay.map { _ in () }.asObservable()
    }

    init(keychainProvider: KeychainProvider, realmProvider: RealmProvider) {
        self.keychainProvider = keychainProvider
        self.realmProvider = realmProvider
    }

    func fetchData() {
        guard let userId = keychainProvider.userId else { return }
        realmProvider.fetchUser(withId: userId).bind(to: userRelay).disposed(by: bag)
    }

    func update(user: User) {
        userRelay.accept(user)
    }
}
