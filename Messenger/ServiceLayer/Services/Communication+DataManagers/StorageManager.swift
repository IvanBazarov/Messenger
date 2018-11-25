//
//  StorageManager.swift
//  Messenger
//
//  Created by Иван Базаров on 04.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

class StorageManager: ProfileDataManager {
    private let coreDataStack: CoreDataStack
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    func saveData(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler) {
        AppUser.getAppUser(in: coreDataStack.saveContext) { (appUser) in
            guard let appUser = appUser else {
                DispatchQueue.main.async {
                    completion(SavingErrors.loadDataError)
                }
                return
            }
            if newProfile.name != oldProfile.name {
                appUser.currentUser?.name = newProfile.name
            }
            if newProfile.description != oldProfile.description {
                appUser.userDescription = newProfile.description
            }
            if newProfile.userImageData
                != oldProfile.userImageData {
                appUser.image = newProfile.userImageData
            }
            self.coreDataStack.performSave(in: self.coreDataStack.saveContext) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    func readData(completion: @escaping CompletionProfileLoader) {
        AppUser.getAppUser(in: coreDataStack.saveContext) { (appUser) in
            let profile: UserProfile
            if let appUser = appUser {
                let name = appUser.currentUser?.name ?? UIDevice.current.name
                let descritption = appUser.userDescription ?? ""
                let imageData = appUser.image ??
                    UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0)
                profile = UserProfile(name: name, description: descritption, userImageData: imageData!)
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                assert(false, "AppUser is nil")
            }
        }
    }
}
