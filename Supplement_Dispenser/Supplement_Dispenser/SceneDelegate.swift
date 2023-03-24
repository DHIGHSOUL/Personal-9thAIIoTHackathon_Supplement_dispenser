//
//  SceneDelegate.swift
//  Supplement_Dispenser
//
//  Created by ROLF J. on 2022/07/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let mainViewController = MainViewController()
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        if didClickNotificationNumber == 1 {
            MainViewController().afterClickNotification()
            didClickNotificationNumber = 0
            notificationTime = ""
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

