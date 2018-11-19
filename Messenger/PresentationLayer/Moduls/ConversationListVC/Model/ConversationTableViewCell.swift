//
//  ConversationTableViewCell.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    private func setMessageFont() {
        if message != nil {
            if hasUnreadMessages {
                messageLabel.font = .boldSystemFont(ofSize: 14.0)
            } else {
                messageLabel.font = .systemFont(ofSize: 14.0)
            }
        } else {
            messageLabel.font = .italicSystemFont(ofSize: 14.0)
        }
    }
    var name: String? {
        didSet {
            if name == "" {
                nameLabel.text = "No name"
            } else {
                nameLabel.text = name
            }
        }
    }
    var message: String? {
        didSet {
            if message != nil {
                messageLabel.text = message
            } else {
                messageLabel.text = "No messages yet"
            }
            setMessageFont()
        }
    }
    var date: Date? {
        didSet {
            if date != nil {
                let dateFormatter = DateFormatter()
                if Calendar.current.isDateInToday(date!) {
                    dateFormatter.dateFormat = "HH:mm"
                } else {
                    dateFormatter.dateFormat = "dd MMM"
                }
                dateLabel.text = dateFormatter.string(from: date!)
                dateLabel.sizeToFit()
                dateLabel.layoutIfNeeded()
            } else {
                dateLabel.text = ""
            }
        }
    }
    var online: Bool = true {
        didSet {
            if online {
                self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 204/255, alpha: 0.5)
            } else {
                self.backgroundColor = .white
            }
        }
    }
    var hasUnreadMessages: Bool = true {
        didSet {
            setMessageFont()
        }
    }
}
