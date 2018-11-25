//
//  ProfileInteractor.swift
//  Messenger
//
//  Created by Иван Базаров on 18.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol IProfileInteractor {
    var profile: IProfile! { get set }
    var profileDataManager: ProfileDataManager { get set }
    func loadProfile(completion: @escaping () -> Void)
    func saveProfile(name: String, description: String, imageData: Data, completion: @escaping CompletionSaveHandler)
    var name: String { get }
    var description: String { get }
    var imageData: Data { get }
}
class ProfileInteractor: IProfileInteractor {
    var profile: IProfile!
    var name: String {
        return profile.name
    }
    var description: String {
        return profile.description
    }
    var imageData: Data {
        return profile.userImageData
    }
    var profileDataManager: ProfileDataManager
    init(profileDataManager: ProfileDataManager) {
        self.profileDataManager = profileDataManager
    }
    func loadProfile(completion: @escaping () -> Void) {
        profileDataManager.readData { (profile) in
            self.profile = profile
            completion()
        }
    }
    func saveProfile(name: String, description: String, imageData: Data, completion: @escaping CompletionSaveHandler) {
        let newProfile = UserProfile(name: name, description: description, userImageData: imageData)
        profileDataManager.saveData(newProfile: newProfile, oldProfile: profile) { (error) in
            if error == nil {
                self.profile = newProfile
            }
            completion(error)
        }
    }
}
