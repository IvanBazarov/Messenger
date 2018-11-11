//
//  CommunicationManager.swift
//  Messenger
//
//  Created by Иван Базаров on 28.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

class CommunicationManager: CommunicatorDelegate {
    static let shared = CommunicationManager()
    var storageManager = StorageManager()
    var communicator: MultipeerCommunicator?
    weak var delegate: CommunicationDelegate?
    private init() {
        storageManager.readData { (profile) in
            self.communicator = MultipeerCommunicator(profile: profile)
            self.communicator?.delegate = self
        }
    }
    var conversationDictionary: [String : User] = [:]
    func didFoundUser(userId: String, userName: String?) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            guard let user = User.findOrInsertUser(id: userId, in: saveContext) else { return }
            let conversation = Conversation.findOrInsertConversationWith(id: userId, in: saveContext)
            user.name = userName
            user.isOnline = true
            conversation.isOnline = true
            conversation.user = user
            CoreDataStack.shared.performSave(in: saveContext, completion: nil)
        }
    }
    func didLostUser(userId: String) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            let conversation = Conversation.findOrInsertConversationWith(id: userId, in: saveContext)
            conversation.isOnline = false
            conversation.user?.isOnline = false
            CoreDataStack.shared.performSave(in: saveContext, completion: nil)
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
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            let message:Message
            if let conversation = Conversation.findConversationWith(id: fromUser, in: saveContext) {
                message = Message.insertNewMessage(in: saveContext)
                message.isIncoming = true
                message.convID = conversation.convID
                message.messageText = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessages = true
                conversation.addToMsgHistory(message)
                conversation.lastMsg = message
            } else if let conversation = Conversation.findConversationWith(id: toUser, in: saveContext) {
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
            CoreDataStack.shared.performSave(in: saveContext, completion: nil)
        }
    }
    func didStartSessions() {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            guard let conversations = Conversation.findOnlineConversations(in: saveContext) else { return }
            conversations.forEach { $0.isOnline = false; $0.user?.isOnline = false }
            CoreDataStack.shared.performSave(in: saveContext, completion: nil)
        }
    }
    func stopMultipeerWithUsers() {
        guard let communicator = communicator else { return }
        communicator.advertiser.stopAdvertisingPeer()
        communicator.browser.stopBrowsingForPeers()
    }
    func startMultipeerWithUsers() {
        guard let communicator = communicator else { return }
        communicator.advertiser.startAdvertisingPeer()
        communicator.browser.startBrowsingForPeers()
    }
}
