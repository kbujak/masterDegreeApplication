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

    init(id: String = UUID().uuidString, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }

    init(realm: UserRealm) {
        self.init(id: realm.id, username: realm.username, password: realm.password)
    }

    func createRealm() -> UserRealm {
        return UserRealm(user: self)
    }
}
