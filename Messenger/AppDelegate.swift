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
    static let shared = AppDelegate()
    
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
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }


    // MARK: - Core Data stack

    private lazy var storeUrl: URL = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentsUrl = url.appendingPathComponent("Messenger.sqlite")
        
        return documentsUrl
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        guard let mom = Bundle.main.url(forResource: "Messenger", withExtension: "momd") else { fatalError("Can't search the resource") }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: mom) else { fatalError("Can't search the object model by this url: \(mom)") }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()
    
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    lazy var saveContext:NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    func performSave(in context: NSManagedObjectContext, completion: CompletionSaveHandler?) {
        if context.hasChanges {
            context.perform {
                do {
                    try context.save()
                } catch {
                    completion?(error)
                }
                if let parentContext = context.parent {
                    self.performSave(in: parentContext, completion: completion)
                } else {
                    completion?(nil)
                }
            }
        } else {
            completion?(nil)
        }
    }

}

