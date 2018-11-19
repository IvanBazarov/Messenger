//
//  Message.swift
//  Messenger
//
//  Created by Иван Базаров on 11.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    static func insertNewMessage(in context: NSManagedObjectContext) -> Message {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else {
            fatalError("Can't create Message entity")
        }
        return message
    }
    static func findMessagesFrom(conversationId: String, in context: NSManagedObjectContext, by messageRequester: IMessageFetchRequester) -> [Message]? {
        let request = messageRequester.fetchMessagesFrom(conversationId: conversationId)
        do {
            let messages = try context.fetch(request)
            return messages
        } catch {
            assertionFailure("Can't fetch messages")
            return nil
        }
    }
}
