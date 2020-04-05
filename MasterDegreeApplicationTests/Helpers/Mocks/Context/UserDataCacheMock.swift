//
//  UserDataCacheMock.swift
//  MasterDegreeApplicationTests
//
//  Created by Krystian Bujak on 04/04/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import MasterDegreeApplication

class UserDataCacheMock: UserDataCache {
    var user: User?
    var userUpdated: Observable<Void> = Observable.empty()

    func fetchData() { }
    func update(user: User) { }
}
