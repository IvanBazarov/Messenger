//
//  ICommunicationManager.swift
//  Messenger
//
//  Created by Иван Базаров on 18.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol ICommunicationManager: class, IUserDiscover, ICommunicationFailHandler, IMessageHandler {
    var delegate: CommunicationIntegrator? { get set }
    var communicator: Communicator { get }
    var coreDataStack: CoreDataStack { get }
    var userRequester: IUserFetchRequester { get }
    var conversationRequester: IConversationFetchRequester { get }
    var messageRequester: IMessageFetchRequester { get }
    func didStartSessions()
}
protocol IUserDiscover {
    func didFoundUser(userId: String, userName: String?)
    func didLostUser(userId: String)
}
protocol ICommunicationFailHandler {
    func failedToBrowseUsers(error: Error)
    func failedToAdvertise(error: Error)
}
protocol IMessageHandler {
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func sendMessage(text: String, conversationID: String, completion: @escaping messageHandler)
}
