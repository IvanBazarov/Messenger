//
//  OperationDataManager..swift
//  Messenger
//
//  Created by Иван Базаров on 21.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

struct OperationDataManager {
    var documentsDirectory: URL
    var archiveURL: URL
    let operationQueue = OperationQueue()
    
    init() {
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 1
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = documentsDirectory.appendingPathComponent("user_profile").appendingPathExtension("plist")
    }
    
    func saveProfile(new profile: UserProfile, old: UserProfile, completion: @escaping CompletionSaveHandler) {
        let saveOperation = SaveProfileOperation()
        saveOperation.archiveURL = archiveURL
        saveOperation.completionHandler = completion
        saveOperation.newProfile = profile
        saveOperation.oldProfile = old
        operationQueue.addOperation(saveOperation)
    }
    
    func getProfile(completion: @escaping CompletionProfileLoader) {
        let loadOperation = ProfileLoadingOperation()
        loadOperation.archiveURL = archiveURL
        loadOperation.completionHandler = completion
        operationQueue.addOperation(loadOperation)
    }
}

class ProfileLoadingOperation: Operation {
    var profile: UserProfile!
    var archiveURL: URL!
    var completionHandler: CompletionProfileLoader!
    
    override func main() {
        let name = UserDefaults.standard.string(forKey: "user_name") ?? ""
        let description = UserDefaults.standard.string(forKey: "user_description") ?? "Нет данных в профиле"
        let image: UIImage
        if let imageData =  try? Data(contentsOf: archiveURL), UIImage(data: imageData) != nil {
            image = UIImage(data: imageData)!
        } else {
            image = UIImage(named: "placeholder-user")!
        }
        profile = UserProfile(name: name, description: description, userImage: image)
        OperationQueue.main.addOperation { self.completionHandler(self.profile) }
    }
}

class SaveProfileOperation: Operation {
    var newProfile: UserProfile!
    var oldProfile: UserProfile!
    var completionHandler: CompletionSaveHandler!
    var archiveURL: URL!
    
    override func main() {
        if newProfile.name != oldProfile.name {
            UserDefaults.standard.set(newProfile.name, forKey: "user_name")
        }
        if newProfile.description != oldProfile.name {
            UserDefaults.standard.set(newProfile.description, forKey: "user_description")
        }
        if newProfile.userImage.jpegData(compressionQuality: 1.0) != oldProfile.userImage.jpegData(compressionQuality: 1.0) {
            guard let imageData = newProfile.userImage.jpegData(compressionQuality: 1.0) else {
                OperationQueue.main.addOperation {
                    self.completionHandler(ImageError.convertDataError)
                }
                return
            }
            do {
                try imageData.write(to: archiveURL, options: .noFileProtection)
            } catch let error {
                self.completionHandler(error)
            }
        }
        OperationQueue.main.addOperation {
            self.completionHandler(nil)
        }
    }
}
