//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    var hasUnreadMessages = [false, true, false, false, false, true, false, false, false, false]
    
    var namesArray = ["Ivan", "Petr", "Egor", "Ilya", "Alena", "Vladimir", "Dmitry", "Elena", "Anton", "Donald"]
    let messagesArray = [
         "Основная проблема программистов состоит в том, что их ошибки невозможно предугадать",
         "Итерация свойственна человеку, рекурсия божественна",
         nil,
         "Hello, this is Linus Torvalds, and I pronounce SVN as git",
        "Всегда пишите код так, как будто сопровождать его будет психопат, который знает, где вы живёте",
        nil,
        "Если что-то работает — то не трогай это",
        "Господи, дай мне соурс код Вселенной, час времени и хороший дебаггер",
        "Если отладка — процесс удаления ошибок, то программирование должно быть процессом их внесения",
        nil]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: animated)
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Online", "History"][section]
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationTableViewCell
        
        cell.online = indexPath.section == 0
        cell.name = namesArray[indexPath.row]
        cell.message = messagesArray[indexPath.row]
        cell.date = Date() - Double(indexPath.row) * 3e4
        cell.hasUnreadMessages = hasUnreadMessages[indexPath.row]
        cell.layoutIfNeeded()
 

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ConversationTableViewCell {
            if let conversation = segue.destination as? ConversationViewController {
                conversation.title = cell.name
            }
        }
    }

}
