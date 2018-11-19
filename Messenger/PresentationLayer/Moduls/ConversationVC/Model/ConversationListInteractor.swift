//
//  ConversationListInteractor.swift
//  Messenger
//
//  Created by Иван Базаров on 18.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

typealias IConversationInteractor = IMessageSender & IFetchedResultSettuper
protocol IMessageSender {
    var communicationManager: ICommunicationManager { get }
    func sendMessage(text: String, conversationId: String, completion: @escaping messageHandler)
}
class ConversationInteractor: IConversationInteractor {
    var communicationManager: ICommunicationManager
    init(communicationManager: ICommunicationManager) {
        self.communicationManager = communicationManager
    }
    func sendMessage(text: String, conversationId: String, completion: @escaping messageHandler) {
        communicationManager.sendMessage(text: text, conversationID: conversationId, completion: completion)
    }
    func setupMessagesFetchedResultController(userID: String) -> NSFetchedResultsController<Message> {
        let request = communicationManager.messageRequester.fetchMessagesFrom(conversationId: userID)
        request.fetchBatchSize = 20
        let mainContext = communicationManager.coreDataStack.mainContext
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
}
