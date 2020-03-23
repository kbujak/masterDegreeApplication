//
//  Validator.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 23/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation

enum Validator {
    case username(String)
    case password(String)
    case retypePassword(String, String)

    func validate() -> Bool {
        switch self {
        case .username(let username): return !username.isEmpty && username != ""
        case .password(let password): return password.count > 5
        case .retypePassword(let password, let retypePassword): return password == retypePassword
        }
    }
}
