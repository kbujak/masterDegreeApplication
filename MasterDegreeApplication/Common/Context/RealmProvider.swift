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
    func fetchUser(withId Id: String) -> Observable<User>
    func fetchUser(withUsername username: String, password: String) -> Observable<User?>
    func fetchUser(withPhrase phrase: String) -> Observable<[User]>
    func addFriend(withUserId userId: String, forUser user: User) -> Observable<User>
    func fetchFriends(forUser user: User) -> Observable<[User]>
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

    func fetchUser(withPhrase phrase: String) -> Observable<[User]> {
        return Observable.create { [weak self] subscriber -> Disposable in
            do {
                guard let `self` = self else { throw AppErrors.unknownError }

                let realm = try self.tryGetRealm()
                let objects = realm.objects(UserRealm.self).filter(NSPredicate(format: "username CONTAINS %@", phrase))
                let users = Array(objects).map { User(realm: $0) }

                subscriber.onNext(users)
                subscriber.onCompleted()
            } catch {
                subscriber.onError(error)
            }
            return Disposables.create()
        }
    }

    func fetchUser(withUsername username: String, password: String) -> Observable<User?> {
        return Observable.create { [weak self] subscriber -> Disposable in
            do {
                guard let `self` = self else { throw AppErrors.unknownError }

                let realm = try self.tryGetRealm()
                let object = realm.objects(UserRealm.self).filter(NSPredicate(format: "username == %@", username))
                let userRealm = object.first

                if let userRealm = userRealm, userRealm.password == password {
                    let user = User(realm: userRealm)
                    subscriber.onNext(user)
                } else {
                    subscriber.onNext(nil)
                }
                subscriber.onCompleted()
            } catch {
                subscriber.onError(error)
            }
            return Disposables.create()
        }
    }

    func addFriend(withUserId userId: String, forUser user: User) -> Observable<User> {
        return Observable.create { [weak self] subscriber -> Disposable in
            do {
                guard let `self` = self else { throw AppErrors.unknownError }

                let realm = try self.tryGetRealm()
                let object = realm.object(ofType: UserRealm.self, forPrimaryKey: user.id)
                if let realmUser = object {
                    try realm.write {
                        realmUser.friendIds.append(userId)
                    }
                    subscriber.onNext(User(realm: realmUser))
                }
                subscriber.onCompleted()
            } catch {
                subscriber.onError(error)
            }
            return Disposables.create()
        }
    }

    func fetchFriends(forUser user: User) -> Observable<[User]> {
        return Observable.create { [weak self] subscriber -> Disposable in
            do {
                guard let `self` = self else { throw AppErrors.unknownError }

                let realm = try self.tryGetRealm()
                let userObject = realm.object(ofType: UserRealm.self, forPrimaryKey: user.id)!
                let objects = realm.objects(UserRealm.self)
                    .filter(NSPredicate(format: "id IN %@", userObject.friendIds))

                let friends = Array(objects.map { User(realm: $0) })
                subscriber.onNext(friends)
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
