//
//  OperationDataManager..swift
//  Messenger
//
//  Created by Иван Базаров on 21.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

struct OperationDataManager: ProfileDataManager {
    var documentsDirectory: URL
    var archiveURL: URL
    let operationQueue = OperationQueue()
    init() {
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 1
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = documentsDirectory.appendingPathComponent("user_profile").appendingPathExtension("plist")
    }
    func saveData(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler) {
        let saveOperation = SaveProfileOperation()
        saveOperation.archiveURL = archiveURL
        saveOperation.completionHandler = completion
        saveOperation.newProfile = newProfile
        saveOperation.oldProfile = oldProfile
        operationQueue.addOperation(saveOperation)
    }
    func readData(completion: @escaping CompletionProfileLoader) {
        let loadOperation = ProfileLoadingOperation()
        loadOperation.archiveURL = archiveURL
        loadOperation.completionHandler = completion
        operationQueue.addOperation(loadOperation)
    }
}

class ProfileLoadingOperation: Operation {
    var profile: IProfile!
    var archiveURL: URL!
    var completionHandler: CompletionProfileLoader!
    override func main() {
        let name = UserDefaults.standard.string(forKey: "user_name") ?? ""
        let description = UserDefaults.standard.string(forKey: "user_description") ?? "Нет данных в профиле"
        let imageData: Data = (try? Data(contentsOf: archiveURL))
            ?? UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0)!
        profile = UserProfile(name: name, description: description, userImageData: imageData)
        OperationQueue.main.addOperation { self.completionHandler(self.profile) }
    }
}

class SaveProfileOperation: Operation {
    var newProfile: IProfile!
    var oldProfile: IProfile!
    var completionHandler: CompletionSaveHandler!
    var archiveURL: URL!
    override func main() {
        if newProfile.name != oldProfile.name {
            UserDefaults.standard.set(newProfile.name, forKey: "user_name")
        }
        if newProfile.description != oldProfile.name {
            UserDefaults.standard.set(newProfile.description, forKey: "user_description")
        }
        if newProfile.userImageData != oldProfile.userImageData {
            do {
                try newProfile.userImageData.write(to: archiveURL, options: .noFileProtection)
            } catch let error {
                self.completionHandler(error)
            }
        }
        OperationQueue.main.addOperation {
            self.completionHandler(nil)
        }
    }
}
