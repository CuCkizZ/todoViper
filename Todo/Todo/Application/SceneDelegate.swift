//
//  SceneDelegate.swift
//  Todo
//
//  Created by Nikita Beglov on 14.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = TaskListBuilder.createTaskList()
        window?.makeKeyAndVisible()
    }
}

