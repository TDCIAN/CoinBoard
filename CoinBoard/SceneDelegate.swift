//
//  SceneDelegate.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func sceneWillEnterForeground(_ scene: UIScene) {
        if UserDefaults.standard.bool(forKey: Constants.IS_DARK_MODE) {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
}
