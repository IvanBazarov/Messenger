//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    var usersDatabase:[User] = []
    var usersDatabaseOnline:[User] = []
    var usersDatabaseOffline:[User] = []
    var ifOnlineArray = [false, true, true, true, false, true, true, false, true, false, false, true, true, true, false, true, true, false, true, true]
    var hasUnreadMessages = [false, true, false, true, true, true, false, false, false, false, false, true, false, true, true, true, false, false, false, false]
    
    var namesArray = ["Ivan", "Petr", "Egor", "Ilya", "Alena", "Vladimir", "Dmitry", "Elena", "Anton", "Donald", "Yuriy", "Vadim", "Maria", "Katya", "Alex", "Gerrit", "Manuel", "Jozef", "Natasha", "Danil"]
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
        nil,
        "В хорошем дизайне добавление вещи стоит дешевле, чем сама эта вещь.",
        "В теории, теория и практика неразделимы. На практике это не так.",
        "Опасайтесь багов в приведенном выше коде; я только доказал корректность, но не запускал его.",
        nil,
        nil,
        "Меня не интересует, будет ли это работаеть на ваших машинах! Мы не отдаем их заказчику!",
        "Иногда лучше остаться спать дома в понедельник, чем провести всю неделю отлаживая написанный в понедельник код.",
        "Итерация свойственна человеку, рекурсия божественна.",
        "Люди, которые думают, что ненавидят компьютеры, на самом деле ненавидят плохих программистов.",
        "Отладка кода — это как охота. Охота на баги."]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDatabase()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setUpDatabase() {
        for i in 0...namesArray.count-1 {
            let Database = User()
            Database.name = namesArray[i]
            Database.message = messagesArray[i]
            Database.hasUnreadMessages = hasUnreadMessages[i]
            Database.date = Date() - Double(i) * 3e4
            Database.online = ifOnlineArray[i]
            usersDatabase.append(Database)
        }
        for i in 0...usersDatabase.count-1 {
            if usersDatabase[i].online {
                usersDatabaseOnline.append(usersDatabase[i])
            }else {
                if usersDatabase[i].message != nil {
                    usersDatabaseOffline.append(usersDatabase[i])
                }
            }
        }
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
        switch (section) {
        case 0: return usersDatabaseOnline.count
        case 1: return usersDatabaseOffline.count
        default: return 0
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Online", "History"][section]
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationTableViewCell
        
        switch (indexPath.section) {
        case 0:
            cell.online = true
            cell.name = usersDatabaseOnline[indexPath.row].name
            cell.message = usersDatabaseOnline[indexPath.row].message
            cell.date = usersDatabaseOnline[indexPath.row].date
            cell.hasUnreadMessages = usersDatabaseOnline[indexPath.row].hasUnreadMessages
        default:
            cell.online = false
            cell.name = usersDatabaseOffline[indexPath.row].name
            cell.message = usersDatabaseOffline[indexPath.row].message
            cell.date = usersDatabaseOffline[indexPath.row].date
            cell.hasUnreadMessages = usersDatabaseOffline[indexPath.row].hasUnreadMessages
        }
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
