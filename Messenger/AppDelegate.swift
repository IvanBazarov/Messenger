//
//  AppDelegate.swift
//  Messenger
//
//  Created by Иван Базаров on 23.09.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpSavedTheme()
        return true
    }
    func setUpSavedTheme() {
        guard let theme = UserDefaults.standard.color(forKey: "theme") else { return }
        UINavigationBar.appearance().backgroundColor = theme
    }
    func applicationWillResignActive(_ application: UIApplication) {
        CommunicationManager.shared.stopMultipeerWithUsers()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        CommunicationManager.shared.didStartSessions()
        CommunicationManager.shared.startMultipeerWithUsers()
    }

}
