//
//  ViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 21/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation

protocol ViewModel: class {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
