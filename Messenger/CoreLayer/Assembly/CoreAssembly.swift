//
//  CoreAssembly.swift
//  Messenger
//
//  Created by Иван Базаров on 18.11.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: CoreDataStack { get }
    var communicator: Communicator { get }
    var conversationRequester: IConversationFetchRequester { get }
    var userRequester: IUserFetchRequester { get }
    var messageRequester: IMessageFetchRequester { get }
}
class CoreAssembly: ICoreAssembly {
    lazy var coreDataStack: CoreDataStack = NestedWorkersCoreDataStack.shared
    lazy var communicator: Communicator = MultipeerCommunicator.shared
    lazy var conversationRequester: IConversationFetchRequester = ConversationFetchRequester()
    lazy var userRequester: IUserFetchRequester = UserFetchRequester()
    lazy var messageRequester: IMessageFetchRequester = MessageFetchRequester()
}
