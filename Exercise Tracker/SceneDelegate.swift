//
//  SceneDelegate.swift
//  Exercise Tracker
//
//  Created by Juvraj on 10/26/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let defaults = UserDefaults.standard
        let tokenExits = defaults.value(forKey:"Token")

        if tokenExits != nil { // if tokenExits has value go to main app screen.
            // means user signed in.
        guard let rootVC = storyboard.instantiateViewController(identifier: "main") as? UITabBarController
        else {
            print("ViewController not found")
            return
        }
        let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
    }
        else { // If user is not signed in go to inital screen
            guard let rootVC = storyboard.instantiateViewController(identifier: "inital") as? IntialViewController
            else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

