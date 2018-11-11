//
//  Conversation.swift
//  Messenger
//
//  Created by Иван Базаров on 11.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    static func insertConversationWith(id: String, in context: NSManagedObjectContext) -> Conversation {
        guard let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation else {
            fatalError("Can't insert Conversation")
        }
        conversation.convID = id
        return conversation
    }
    static func findConversationWith(id: String, in context: NSManagedObjectContext) -> Conversation? {
        let fetchConversationWithId = FetchRequestsManager.shared.fetchConversationWith(id: id)
        do {
            let conversationsWithId = try context.fetch(fetchConversationWithId)
            assert(conversationsWithId.count < 2, "Conversations with id: \(id) more than 1")
            if !conversationsWithId.isEmpty {
                let conversation = conversationsWithId.first!
                return conversation
            } else {
                return nil
            }
        } catch {
            assertionFailure("Can't fetch conversations")
            return nil
        }
    }
    static func findOnlineConversations(in context: NSManagedObjectContext) -> [Conversation]? {
        let fetchRequest = FetchRequestsManager.shared.fetchOnlineConversations()
        do {
            let conversations = try context.fetch(fetchRequest)
            return conversations
        } catch {
            assertionFailure("Can't fetch conversations")
            return nil
        }
    }
    static func findOrInsertConversationWith(id: String, in context: NSManagedObjectContext) -> Conversation {
        guard let conversation = Conversation.findConversationWith(id: id, in: context) else {
            return Conversation.insertConversationWith(id:id, in: context)
        }
        return conversation
    }

}
