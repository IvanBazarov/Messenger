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
    func sendMessage(string: String, to userId: String, completionHandler: messageHandler?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}
