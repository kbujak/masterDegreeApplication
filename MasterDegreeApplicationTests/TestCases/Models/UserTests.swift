//
//  UserTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class UserTests: XCTestCase {
    func testModel_whenInit_ThenNotNil() {
        let model = User(username: "test1", password: "test2")

        XCTAssertNotNil(model)
    }

    func testId_whenInit_ThenIsSame() {
        let id = "testId"
        let model = User(id: id, username: "test1", password: "test2")

        XCTAssertEqual(id, model.id)
    }

    func testUsername_whenInit_ThenIsSame() {
        let username = "testUsername"
        let model = User(username: username, password: "test2")

        XCTAssertEqual(username, model.username)
    }

    func testPassword_whenInit_ThenIsSame() {
        let password = "testPassword"
        let model = User(username: "test1", password: password)

        XCTAssertEqual(password, model.password)
    }
}
