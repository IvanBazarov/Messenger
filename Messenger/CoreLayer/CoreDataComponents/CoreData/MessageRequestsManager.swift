//
//  MessageFetchRequester.swift
//  Messenger
//
//  Created by Иван Базаров on 18.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

import CoreData
protocol IMessageFetchRequester {
    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<Message>
}
class MessageFetchRequester: IMessageFetchRequester {
    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "convID == %@", conversationId)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
}
