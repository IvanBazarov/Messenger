//
//  GeneralSaveProtocol.swift
//  Messenger
//
//  Created by Иван Базаров on 21.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

typealias CompletionSaveHandler = (Error?) -> Void
typealias CompletionProfileLoader = (UserProfile) -> Void

protocol DataManager {
    
    func getProfile(completion: @escaping CompletionProfileLoader)
    func saveProfile(new profile: UserProfile, old: UserProfile, completion: @escaping CompletionSaveHandler)
}

enum ImageError: Error {
    case convertDataError
}
