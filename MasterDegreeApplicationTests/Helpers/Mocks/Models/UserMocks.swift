//
//  UserMocks.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
@testable import MasterDegreeApplication

var userMock1: User {
    return User(id: "user1", username: "John Kowalski", password: "password123")
}

var userMock2: User {
    return User(id: "user2", username: "Anna Mateja", password: "password13")
}

var userMock3: User {
    return User(id: "user3", username: "Kamil Henry", password: "password23")
}
