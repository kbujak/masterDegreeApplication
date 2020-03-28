//
//  AddUserViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation

class AddUserViewModel: ViewModel {
    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func transform(input: AddUserViewModel.Input) -> AddUserViewModel.Output {
        return Output()
    }

    struct Input {

    }

    struct Output {

    }
}
