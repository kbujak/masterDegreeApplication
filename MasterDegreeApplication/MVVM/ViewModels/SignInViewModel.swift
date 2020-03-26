//
//  SignInViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation

class SignInViewModel: ViewModel {
    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func transform(input: SignInViewModel.Input) -> SignInViewModel.Output {
        return Output()
    }

    struct Input {}

    struct Output {}
}
