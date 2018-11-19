//
//  ConversationsListModel.swift
//  Messenger
//
//  Created by Иван Базаров on 18.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import CoreData

typealias IConversationListFetcher = IConversationList & IFetchedResultSettuper
protocol IConversationList {
    var communicationManager: ICommunicationManager { get }
    func setIntegrator(communicationIntegrator: CommunicationIntegrator)
}
@objc protocol IFetchedResultSettuper {
    @objc optional func setupConversationsFetchedResultController() -> NSFetchedResultsController<Conversation>
    @objc optional func setupMessagesFetchedResultController(userID: String) -> NSFetchedResultsController<Message>
}
class ConversationListInteractor: IConversationListFetcher {
    var communicationManager: ICommunicationManager
    init(communicationManager: ICommunicationManager) {
        self.communicationManager = communicationManager
    }
    func setIntegrator(communicationIntegrator: CommunicationIntegrator) {
        communicationManager.delegate = communicationIntegrator
    }
    func setupConversationsFetchedResultController() -> NSFetchedResultsController<Conversation> {
        let request = communicationManager.conversationRequester.fetchConversations()
        request.fetchBatchSize = 20
        let mainContext = communicationManager.coreDataStack.mainContext
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: "isOnline", cacheName: nil)
        return fetchResultController
    }
}
