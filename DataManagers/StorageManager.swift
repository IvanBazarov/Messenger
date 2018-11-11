//
//  StorageManager.swift
//  Messenger
//
//  Created by Иван Базаров on 04.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

class StorageManager: DataManager {
    private let coreDataStack = CoreDataStack.shared
    func saveData(newProfile: UserProfile, oldProfile: UserProfile, completion: @escaping CompletionSaveHandler) {
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
            if newProfile.userImage.jpegData(compressionQuality: 1.0) != oldProfile.userImage.jpegData(compressionQuality: 1.0) {
                appUser.image = newProfile.userImage.jpegData(compressionQuality: 1.0)
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
                let image: UIImage
                if let imageData = appUser.image {
                    image = UIImage(data: imageData) ?? UIImage(named: "placeholder-user")!
                } else {
                    image = UIImage(named: "placeholder-user")!
                }
                profile = UserProfile(name: name, description: descritption, userImage: image)
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                assert(false, "AppUser is nil")
            }
        }
    }
}
