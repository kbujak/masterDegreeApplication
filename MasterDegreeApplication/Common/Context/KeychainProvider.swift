//
//  KeychainProvider.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import KeychainSwift

fileprivate enum AuthorizationProviderKey: String {
    case userId
}

protocol KeychainProvider: class {
    var userId: String? { get set }

    func clear()
}

class KeychainProviderImpl: KeychainProvider {
    enum Key: String {
        case userId
    }

    private let keychain: KeychainSwift

    var userId: String? {
        get { return keychain.get(Key.userId.rawValue) }
        set {
            if let value = newValue, !value.isEmpty {
                keychain.set(value, forKey: Key.userId.rawValue)
            } else {
                keychain.delete(Key.userId.rawValue)
            }
        }
    }

    init(keychain: KeychainSwift = KeychainSwift()) {
        self.keychain = keychain
    }

    func clear() {
        keychain.clear()
    }
}
