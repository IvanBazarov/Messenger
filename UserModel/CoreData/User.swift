//
//  User.swift
//  Messenger
//
//  Created by Иван Базаров on 11.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

extension User {
    static func insertUserWith(id: String, in context: NSManagedObjectContext) -> User {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {
            fatalError("Can't insert User")
        }
        user.userID = id
        return user
    }
    static func findOrInsertUser(id: String, in context: NSManagedObjectContext) -> User? {
        let request = FetchRequestsManager.shared.fetchUserWithID(id: id)
        do {
            let users = try context.fetch(request)
            assert(users.count < 2, "Users with id \(id) more than 1")
            if !users.isEmpty {
                return users.first!
            } else {
                return User.insertUserWith(id:id, in: context)
            }
        } catch {
            assertionFailure("Can't fetch users")
            return nil
        }
    }
}
