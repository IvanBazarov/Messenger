//
//  FetchRequestsManager.swift
//  Messenger
//
//  Created by Иван Базаров on 11.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationFetchRequester {
    func fetchNonEmptyOnlineConversations() -> NSFetchRequest<Conversation>
    func fetchConversations() -> NSFetchRequest<Conversation>
    func fetchOnlineConversations() -> NSFetchRequest<Conversation>
    func fetchConversationWith(id: String) -> NSFetchRequest<Conversation>
}

class ConversationFetchRequester: IConversationFetchRequester {
    func fetchNonEmptyOnlineConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "msgHistory.@count > 0 AND user.isOnline == 1")
        return request
    }
    func fetchConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let onlineSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: false)
        request.sortDescriptors = [onlineSortDescriptor, dateSortDescriptor]
        return request
    }
    func fetchOnlineConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }
    func fetchConversationWith(id: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "convID == %@", id)
        return request
    }

}
