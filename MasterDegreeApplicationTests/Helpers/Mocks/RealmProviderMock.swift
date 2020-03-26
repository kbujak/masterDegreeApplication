//
//  RealmProviderMock.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 25/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import RealmSwift
import RxSwift
@testable import MasterDegreeApplication

class RealmProviderMock: RealmProvider {
    func clear() { }

    private let queue = DispatchQueue(label: "realmMock", qos: .background, attributes: .concurrent)

    func createUser(withUser user: User) -> Observable<User> {
        return Observable.create { [weak self] subscriber -> Disposable in
            do {
                guard let `self` = self else { throw AppErrors.unknownError }

                let realm = try self.tryGetRealm()
                let object = user.createRealm()
                try realm.write {
                    realm.add(object)
                }

                subscriber.onNext(user)
                subscriber.onCompleted()
            } catch {
                subscriber.onError(error)
            }
            return Disposables.create()
        }
    }

    func fetchUser(withId Id: String) -> Observable<User> {
        return Observable.create { [weak self] subscriber -> Disposable in
            do {
                guard let `self` = self else { throw AppErrors.unknownError }

                let realm = try self.tryGetRealm()
                let object = realm.object(ofType: UserRealm.self, forPrimaryKey: Id)

                guard let userRealm = object else { throw AppErrors.userNotFound }
                let user = User(realm: userRealm)
                subscriber.onNext(user)
                subscriber.onCompleted()
            } catch {
                subscriber.onError(error)
            }
            return Disposables.create()
        }
    }

    private func tryGetRealm() throws -> Realm {
        return try queue.sync {
            try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        }
    }
}