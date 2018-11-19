//
//  UserFetchRequester.swift
//  Messenger
//
//  Created by Иван Базаров on 18.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

protocol IUserFetchRequester {
    func fetchUserWith(userId: String) -> NSFetchRequest<User>
    func fetchOnlineUsers() -> NSFetchRequest<User>
}
class UserFetchRequester: IUserFetchRequester {
    func fetchUserWith(userId: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", userId)
        return request
    }
    func fetchOnlineUsers() -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }
}
