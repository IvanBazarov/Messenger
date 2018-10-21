//
//  UserClass.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String = ""
    var message: String?
    var hasUnreadMessages: Bool = false
    var date: Date = Date()
    var online: Bool = false
}
