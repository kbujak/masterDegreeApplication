//
//  ValidatorTests.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import XCTest
@testable import MasterDegreeApplication

class ValidatorTests: XCTestCase {

    func testUsername_whenEmpty_thenFalse() {
        XCTAssertFalse(Validator.username("").validate())
    }

    func testUsername_whenNotEmpty_thenTrue() {
        XCTAssertTrue(Validator.username("test123").validate())
    }

    func testPassword_whenLessThan5_thenFalse() {
        XCTAssertFalse(Validator.password("").validate())
    }

    func testPassword_whenEqual5_thenFalse() {
        XCTAssertFalse(Validator.password("test1").validate())
    }

    func testPassword_whenMoreThan5_thenTrue() {
        XCTAssertTrue(Validator.password("test12").validate())
    }

    func testRetypePassword_whenNotSame_thenFalse() {
        XCTAssertFalse(Validator.retypePassword("test1", "test2").validate())
    }

    func testRetypePassword_whenSame_thenTrue() {
        XCTAssertTrue(Validator.retypePassword("test", "test").validate())
    }
}
