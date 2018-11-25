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
    private let rootAssembly = RootAssembly()
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpSavedTheme()
        guard let rootVC = window?.rootViewController as? UINavigationController,
            let conversationVC = rootVC.topViewController as? ConversationsListViewController else { return true }
        conversationVC.assembly = rootAssembly.presentationAssembly
        conversationVC.conversationListInteractor = rootAssembly.presentationAssembly.getConversationListInteractor()
        return true
    }
    func setUpSavedTheme() {
        guard let theme = UserDefaults.standard.color(forKey: "theme") else { return }
        UINavigationBar.appearance().backgroundColor = theme
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let communicationManager = rootAssembly.presentationAssembly.serviceAssembly.communicationManager
        communicationManager.didStartSessions()
    }

}
