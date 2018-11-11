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
    func readData(completion: @escaping CompletionProfileLoader)
    func saveData(newProfile: UserProfile, oldProfile: UserProfile, completion: @escaping CompletionSaveHandler)
}

enum SavingErrors: Error {
    case loadDataError
    case convertDataError
}
