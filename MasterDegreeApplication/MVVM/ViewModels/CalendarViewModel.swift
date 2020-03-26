//
//  CalendarViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 26/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation

class CalendarViewModel: ViewModel {
    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func transform(input: CalendarViewModel.Input) -> CalendarViewModel.Output {
        return Output()
    }

    struct Input {

    }

    struct Output {

    }
}
