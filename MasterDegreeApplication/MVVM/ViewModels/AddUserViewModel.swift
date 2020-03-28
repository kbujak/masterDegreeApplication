//
//  AddUserViewModel.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 28/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddUserViewModel: ViewModel {
    private let context: Context

    init(context: Context) {
        self.context = context
    }

    func transform(input: AddUserViewModel.Input) -> AddUserViewModel.Output {
        let users = input.search
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.asyncInstance)
            .flatMapLatest { [weak self] phrase -> Observable<[User]> in
                guard let `self` = self else { return Observable.error(AppErrors.unknownError) }
                return self.context.realmProvider.fetchUser(withPhrase: phrase)
            }

        return Output(
            users: users
        )
    }

    struct Input {
        let search: Observable<String>
    }

    struct Output {
        let users: Observable<[User]>
    }
}
