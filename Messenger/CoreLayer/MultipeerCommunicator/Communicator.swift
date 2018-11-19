//
//  Communicator.swift
//  Messenger
//
//  Created by Иван Базаров on 28.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

typealias messageHandler = (_ succes: Bool, _ error: Error?) -> Void

protocol Communicator {
    func sendMessage(text: String, to userId: String, completionHandler: messageHandler?)
    func startCommunication(name: String)
    var delegate: ICommunicationManager? {get set}
    var online: Bool {get set}
}
