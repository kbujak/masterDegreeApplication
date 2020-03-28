//
//  ContextBuilder.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 25/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import KeychainSwift
import RealmSwift
@testable import MasterDegreeApplication

class ContextBuilder {
    var realmProvider: RealmProvider?
    var keychainProvider: KeychainProvider?

    func with(keychainProvider: KeychainProvider) -> ContextBuilder {
        self.keychainProvider = keychainProvider
        return self
    }

    func with(realmProvider: RealmProvider) -> ContextBuilder {
        self.realmProvider = realmProvider
        return self
    }

    func build() -> Context {
        return Context(
            realmProvider: realmProvider ?? RealmProviderMock(),
            keychainProvider: keychainProvider ?? KeychainProviderMock()
        )
    }
}
