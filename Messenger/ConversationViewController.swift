//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class ConversationViewController: UITableViewController {

    let randomMessagesArray = ["Сложность программы растет до тех пор, пока не превысит способности программиста","Для того, чтобы неординарно мыслить, не надо быть гением, провидцем и даже выпускником университета. Достаточно иметь почву для размышлений и умение мечтать","Машины должны работать. Люди должны думать...","Компьютеры — это как велосипед. Только для нашего сознания.","Если Вашего бизнеса нет в Интернете, то Вас нет в бизнесе!","Осторожнее с тем, что вы постите на Facebook. Что бы это ни было, это еще всплывет когда-нибудь в вашей жизни.","Тот, у кого есть компьютер, располагает всеми опубликованными знаниями."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseIdentifier: String
        if indexPath.row < 4 {
            reuseIdentifier = "incomingMsgCell"
        } else {
            reuseIdentifier = "outgoingMsgCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatTableViewCell
        cell.msg = self.randomMessagesArray[indexPath.row]
        return cell
    
    }
}
