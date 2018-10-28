//
//  UserClass.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class User: NSObject {
    var userID: String
    var name: String?
    var message: String?
    var hasUnreadMessages: Bool
    var date: Date?
    var online: Bool 
    var messageHistory: [Message] = []
    
    init(userID: String, name: String?) {
        self.userID = userID
        self.name = name
        hasUnreadMessages = false
        online = true
    }
    
    enum Message {
        case incoming(String)
        case outgoing(String)
    }
}
