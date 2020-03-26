//
//  SceneDelegate.swift
//  MasterDegreeApplication
//
//  Created by Krystian Bujak on 19/03/2020.
//  Copyright © 2020 Booyac IT. All rights reserved.
//

import UIKit
import SwiftUI
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        print(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString)
        let realmProvider = RealmProviderImpl()
        let keychainProvider = KeychainProviderImpl()
        let context = Context(
            realmProvider: realmProvider,
            keychainProvider: keychainProvider
        )

        let appCoordinator = architecture == .MVVM
            ? MVVMAppCoordinator(context: context)
            : MVCAppCoordinator(context: context)
        self.appCoordinator = appCoordinator

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            appCoordinator.start(in: window)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
