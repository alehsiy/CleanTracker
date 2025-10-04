//
//  SceneDelegate.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 17.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: scene)
        self.window = window
        
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        Task {
            let isAuthenticated = await AuthService.shared.isAuthenticated()

            await MainActor.run {
                if isAuthenticated {
                    let homeVC = HomeViewController()
                    let navController = UINavigationController(rootViewController: homeVC)
                    window.rootViewController = navController
                } else {
                    let authVC = AuthViewController()
                    window.rootViewController = authVC
                }

                window.makeKeyAndVisible()
                self.window = window
            }
        }
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserLogin),
            name: .userDidLogin,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserLogout),
            name: .userDidLogout,
            object: nil
        )
    }

    @objc
    private func handleUserLogin() {
        switchToHomeScreen()
    }

    @objc
    private func handleUserLogout() {
        switchToAuthScreen()
    }

    private func switchToHomeScreen() {
        let homeVC = HomeViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        switchRootViewController(to: navController)
    }

    private func switchToAuthScreen() {
        let authVC = AuthViewController()
        switchRootViewController(to: authVC)
    }

    private func switchRootViewController(to viewController: UIViewController) {
        guard let window = self.window else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        }, completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
    static let userDidLogin = Notification.Name("userDidLogin")
}
