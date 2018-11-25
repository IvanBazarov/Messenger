//
//  CommunicationManager.swift
//  Messenger
//
//  Created by Иван Базаров on 28.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

class CommunicationManager: ICommunicationManager {
    weak var delegate: CommunicationIntegrator?
    var communicator: Communicator
    var coreDataStack: CoreDataStack
    var userRequester: IUserFetchRequester
    var conversationRequester: IConversationFetchRequester
    var messageRequester: IMessageFetchRequester
    init(name: String, communicator: Communicator,
         coreDataStack: CoreDataStack, userRequester: IUserFetchRequester,
         conversationRequester: IConversationFetchRequester, messageRequester: IMessageFetchRequester) {
        self.communicator = communicator
        self.userRequester = userRequester
        self.conversationRequester = conversationRequester
        self.messageRequester = messageRequester
        self.coreDataStack = coreDataStack
        self.communicator.delegate = self
        self.communicator.startCommunication(name: name)
    }
    var conversationDictionary: [String : User] = [:]
    func didFoundUser(userId: String, userName: String?) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            guard let user = User.findOrInsertUser(id: userId, in: saveContext, by: self.userRequester) else { return }
            let conversation = Conversation.findOrInsertConversationWith(conversationId: userId, in: saveContext, by: self.conversationRequester)
            user.name = userName
            user.isOnline = true
            conversation.isOnline = true
            conversation.user = user
            self.coreDataStack.performSave(in: saveContext, completion: nil)
           // guard let convVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "convVC") as? ConversationViewController else { return }
           // convVC.onlineUser = true
        }
    }
    func didLostUser(userId: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let conversation = Conversation.findOrInsertConversationWith(conversationId: userId, in: saveContext, by: self.conversationRequester)
            conversation.isOnline = false
            conversation.user?.isOnline = false
            self.coreDataStack.performSave(in: saveContext, completion: nil)
            //guard let convVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "convVC") as? ConversationViewController else { return }
            //convVC.onlineUser = false
        }
    }
    func failedToBrowseUsers(error: Error) {
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.handleError(error: error)
        }
    }
    func failedToAdvertise(error: Error) {
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.handleError(error: error)
        }
    }
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let message:Message
            if let conversation = Conversation.findConversationWith(conversationId: fromUser, in: saveContext, by: self.conversationRequester) {
                message = Message.insertNewMessage(in: saveContext)
                message.isIncoming = true
                message.convID = conversation.convID
                message.messageText = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessages = true
                conversation.addToMsgHistory(message)
                conversation.lastMsg = message
            } else if let conversation = Conversation.findConversationWith(conversationId: toUser, in: saveContext, by: self.conversationRequester) {
                message = Message.insertNewMessage(in: saveContext)
                message.isIncoming = false
                message.convID = conversation.convID
                message.messageText = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessages = false
                conversation.addToMsgHistory(message)
                conversation.lastMsg = message
            }
            self.coreDataStack.performSave(in: saveContext, completion: nil)
        }
    }
    func sendMessage(text: String, conversationID: String, completion: @escaping messageHandler) {
        communicator.sendMessage(text: text, to: conversationID, completionHandler: completion)
    }
    func didStartSessions() {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            DispatchQueue.main.sync {
                self.communicator.online = false
            }
            guard let conversations = Conversation.findOnlineConversations(in: saveContext, by: self.conversationRequester)
                else {
                    DispatchQueue.main.sync {
                        self.communicator.online = true
                    }
                    return
            }
            conversations.forEach { $0.isOnline = false; $0.user?.isOnline = false }
            self.coreDataStack.performSave(in: saveContext, completion: nil)
            DispatchQueue.main.sync {
                self.communicator.online = true
            }
        }
    }
}
