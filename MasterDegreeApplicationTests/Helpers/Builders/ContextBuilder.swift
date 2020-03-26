//
//  ContextBuilder.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 25/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
@testable import MasterDegreeApplication

class ContextBuilder {
    var realmProvider: RealmProvider?

    func build() -> Context {
        return Context(
            realmProvider: realmProvider ?? RealmProviderMock()
        )
    }
}
