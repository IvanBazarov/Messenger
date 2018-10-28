//
//  CommunicatorDelegate.swift
//  Messenger
//
//  Created by Иван Базаров on 28.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate : class {
   
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func didFoundUser(userId: String, userName: String?)
    func didLostUser(userId: String)
    func failedToBrowseUsers(error: Error)
    func failedToAdvertise(error: Error)
    
}
