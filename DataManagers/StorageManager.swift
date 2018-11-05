//
//  StorageManager.swift
//  Messenger
//
//  Created by Иван Базаров on 04.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

class StorageManager: NSObject {
    
    private let appDelegate = AppDelegate.shared
    
    func saveData(completion: @escaping CompletionSaveHandler){
        appDelegate.performSave(in: appDelegate.saveContext) { (error) in
            DispatchQueue.main.async {
                completion(error)
            }
        }
        
    }
    func readData(completion: @escaping (AppUser?) -> Void){
        AppUser.getAppUser(in: appDelegate.saveContext) { (appUser) in
            DispatchQueue.main.async {
                completion(appUser)
            }
        }
    }
    
}
