//
//  RealmProvider.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 25/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol RealmProvider: class {
    func createUser(withUser user: User) -> Observable<User>
    func clear()
}

class RealmProviderImpl: RealmProvider {
    private let queue = DispatchQueue(label: "masterDegree", qos: .background, attributes: .concurrent)

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

    func clear() {
        do {
            let realm = try tryGetRealm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
}

private extension RealmProviderImpl {
    func tryGetRealm() throws -> Realm {
        return try queue.sync {
            try Realm()
        }
    }
}
