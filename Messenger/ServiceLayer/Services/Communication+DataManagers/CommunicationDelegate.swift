//
//  CommunicationDelegate.swift
//  Messenger
//
//  Created by Иван Базаров on 28.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation

protocol CommunicationDelegate : class {
    func updateUserData()
    func handleError(error: Error)
}
