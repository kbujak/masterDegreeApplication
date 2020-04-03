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
    private let queue = DispatchQueue(label: "realmMock", qos: .background, attributes: .concurrent)

    var createUserWithUserCallCount = 0
    var createUserWithUserClosure: (User) -> Observable<User> = { _ in Observable.empty() }

    func createUser(withUser user: User) -> Observable<User> {
        createUserWithUserCallCount += 1
        return createUserWithUserClosure(user)
    }

    var fetchUserWithIdCallCount = 0
    var fetchUserWithIdCallClosure: (String) -> Observable<User> = { _ in Observable.empty() }

    func fetchUser(withId Id: String) -> Observable<User> {
        fetchUserWithIdCallCount += 1
        return fetchUserWithIdCallClosure(Id)
    }

    var fetchUserWithUsernameCallCount = 0
    var fetchUserWithUsernameCallClosure: (String, String) -> Observable<User?> = { _, _ in Observable.empty() }

    func fetchUser(withUsername username: String, password: String) -> Observable<User?> {
        fetchUserWithUsernameCallCount += 1
        return fetchUserWithUsernameCallClosure(username, password)
    }

    var fetchUserWithPhraseCallCount = 0
    var fetchUserWithPhraseCallClosure: (String) -> Observable<[User]> = { _ in Observable.empty() }

    func fetchUser(withPhrase phrase: String) -> Observable<[User]> {
        fetchUserWithPhraseCallCount += 1
        return fetchUserWithPhraseCallClosure(phrase)
    }

    var inviteUserCallCount = 0
    var inviteUserCallClosure: (User) -> Observable<User> = { _ in Observable.empty() }

    func invite(user: User) -> Observable<User> {
        inviteUserCallCount += 1
        return inviteUserCallClosure(user)
    }

    func clear() { }
}
