//
//  User.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RealmSwift

struct User {
    let id: String
    let username: String
    let password: String
    let friendIds: [String]

    init(id: String = UUID().uuidString, friendIds: [String] = [], username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
        self.friendIds = friendIds
    }

    init(realm: UserRealm) {
        self.init(id: realm.id, friendIds: Array(realm.friendIds), username: realm.username, password: realm.password)
    }

    func createRealm() -> UserRealm {
        return UserRealm(user: self)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
