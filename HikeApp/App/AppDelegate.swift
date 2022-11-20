//
//  AppDelegate.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 11.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController()
        window?.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(router: Router())
        appCoordinator?.start()
        
        return true
    }
}
