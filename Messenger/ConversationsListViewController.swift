//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController, ThemesViewControllerDelegate, CommunicationDelegate {
    func updateUserData() {
        userConversations = Array(CommunicationManager.shared.conversationDictionary.values)
        sortUserConversations()
        tableView.reloadData()
    }
    
    func handleError(error: Error) {
        print("error")
    }
    
    var userConversations: [User] = []
    let cellId = "ConversationCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 65
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommunicationManager.shared.delegate = self
        updateUserData()
    }
    
    func sortUserConversations() {
        userConversations.sort(by: sortFunction(firstUser:secondUser:))
    }
    
    func sortFunction(firstUser: User, secondUser: User) -> Bool {
        if let firstDate = firstUser.date, let firstName = firstUser.name {
            if let secondDate = secondUser.date, let secondName = secondUser.name {
                if firstDate.timeIntervalSinceNow != secondDate.timeIntervalSinceNow {
                    return firstDate.timeIntervalSinceNow > secondDate.timeIntervalSinceNow
                }
                return firstName > secondName
            }
            return true
        } else {
            return false
        }
    }

// TableView functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userConversations.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Online", "History"][section]
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationTableViewCell
    
        let userConversation = userConversations[indexPath.row]
        cell.name = userConversation.name
        cell.message = userConversation.message
        cell.date = userConversation.date
        cell.hasUnreadMessages = userConversation.hasUnreadMessages
        cell.online = userConversation.online
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showChat", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat", let indexPath = sender as? IndexPath {
            let conversationViewController = segue.destination as! ConversationViewController
            let userConversation: User
            userConversation = userConversations[indexPath.row]
            conversationViewController.userConversation = userConversation
            if userConversations[indexPath.row].name == "" {
                conversationViewController.navigationItem.title = "No name"
            }else {
                conversationViewController.navigationItem.title = userConversations[indexPath.row].name
            }
        }
    }
    
 // Themes block
    
    @IBAction func themesTapped(_ sender: Any) {
        let themesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemesViewController") as! ThemesViewController
        themesVC.delegate = self
        if UserDefaults.standard.color(forKey: "theme") == nil {
            themesVC.navigationController?.navigationBar.backgroundColor = .white
            themesVC.view.backgroundColor = .yellow
        }
        
        let navController = UINavigationController(rootViewController: themesVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func themesTappedSwift(_ sender: Any) {
        let themesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemesViewControllerSwift") as! ThemesViewControllerSwift
        
        if UserDefaults.standard.color(forKey: "theme") == nil {
            themesVC.navigationController?.navigationBar.backgroundColor = .white
            themesVC.view.backgroundColor = .yellow
        }
        themesVC.onChangeTheme = changeThemeWithClosure
    }
    
    lazy var changeThemeWithClosure: (UIColor) -> () = { [weak self] (theme: UIColor) in
        self?.logThemeChanging(selectedTheme: theme)
    }
    
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print(selectedTheme)
    }

}


