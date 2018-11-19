//
//  GeneralSaveProtocol.swift
//  Messenger
//
//  Created by Иван Базаров on 21.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

typealias CompletionSaveHandler = (Error?) -> Void
typealias CompletionProfileLoader = (IProfile) -> Void

protocol ProfileDataManager {
    func readData(completion: @escaping CompletionProfileLoader)
    func saveData(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler)
}

enum SavingErrors: Error {
    case loadDataError
    case convertDataError
}
