//
//  ChatTableViewCell.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit
import QuartzCore

protocol ChatCellConfiguration: class {
    var msg: String? { get set }
}

class ChatTableViewCell: UITableViewCell, ChatCellConfiguration {
    
    @IBOutlet weak var chatGeneralView: UILabel!
    
    var msg: String? {
        didSet {
            self.chatGeneralView.text = msg
            
        }
    }
}


