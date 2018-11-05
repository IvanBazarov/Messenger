//
//  AppUser.swift
//  Messenger
//
//  Created by Иван Базаров on 05.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import CoreData

extension AppUser {
    static func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "FetchUserData"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else {
            return nil
        }
        appUser.name = UIDevice.current.name
        appUser.image = UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0)
        appUser.userDescription = ""
        return appUser
    }
    
    static func getAppUser(in context: NSManagedObjectContext, completion: @escaping (AppUser?) -> Void) {
        context.perform {
            var appUser: AppUser?
            guard let model = context.persistentStoreCoordinator?.managedObjectModel else {return}
            guard let request = AppUser.fetchRequest(model: model) else {return}
            do {
                let results = try context.fetch(request)
                assert(results.count < 2,"Multiple AppUsers found!")
                if results.isEmpty {
                    appUser = AppUser.insertAppUser(in: context)
                } else {
                    appUser = results.first!
                }
                
                completion(appUser)
                
            } catch {
                print ("Failed to fetch AppUser:\(error)")
            }
        }
        
    }
    
}
