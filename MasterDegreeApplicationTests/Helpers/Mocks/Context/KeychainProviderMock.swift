//
//  KeychainProviderMock.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
@testable import MasterDegreeApplication

class KeychainProviderMock: KeychainProvider {
    var userId: String?

    func clear() { }
}
