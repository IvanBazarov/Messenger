//
//  CommunicationManager.swift
//  Messenger
//
//  Created by Иван Базаров on 28.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {
    
    static let shared = CommunicationManager()
    var storageManager = StorageManager()
    var communicator: MultipeerCommunicator!
    weak var delegate: CommunicationDelegate?
    
    private init() {
        storageManager.readData { (appUser) in
            guard let appUser = appUser else {
                assert(false, "Can't browse users")
                return
            }
            self.communicator = MultipeerCommunicator(profile: appUser)
            self.communicator.delegate = self
        }
    }
   
    var conversationDictionary: [String : User] = [:]
    
    
    func didFoundUser(userId: String, userName: String?) {
        if let userConversation = conversationDictionary[userId] {
            userConversation.online = true
        } else {
            let userConversation = User(userID: userId, name: userName)
            userConversation.online = true
            conversationDictionary[userId] = userConversation
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUserData()
        }
    }
    
    func didLostUser(userId: String) {
        if let userConversation = conversationDictionary[userId] {
            userConversation.online = false
            conversationDictionary.removeValue(forKey: userId)
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUserData()
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
        if let userConversation = conversationDictionary[fromUser] {
            let message = User.Message.incoming(text)
            userConversation.messageHistory.append(message)
            userConversation.date = Date()
            userConversation.message = text
            userConversation.hasUnreadMessages = true
        } else if let userConversation = conversationDictionary[toUser] {
            let message = User.Message.outgoing(text)
            userConversation.messageHistory.append(message)
            userConversation.date = Date()
            userConversation.message = text
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUserData()
        }
    }
}
