//
//  UserRealm.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 25/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealm: Object {
    enum Properties: String {
        case id, username, password
    }

    @objc dynamic var id: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var password: String = ""

    convenience init(id: String, username: String, password: String) {
        self.init()
        self.id = id
        self.username = username
        self.password = password
    }

    convenience init(user: User) {
        self.init(id: user.id, username: user.username, password: user.password)
    }

    override class func primaryKey() -> String? {
        return Properties.username.rawValue
    }
}
