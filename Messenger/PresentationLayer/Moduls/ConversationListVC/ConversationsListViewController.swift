//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UITableViewController, ThemesViewControllerDelegate, CommunicationIntegrator {
    func updateUserData() {
    }
    func handleError(error: Error) {
        print("error")
    }
    var assembly: IPresentationAssembly!
    var conversationListInteractor: IConversationListFetcher!
    var fetchResultsController: NSFetchedResultsController<Conversation>!
    var userConversations: [User] = []
    let cellId = "ConversationCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 65
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        fetchConversations()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversationListInteractor.setIntegrator(communicationIntegrator: self)
        updateUserData()
    }
    func fetchConversations() {
        if conversationListInteractor.setupConversationsFetchedResultController == nil {
            fatalError("Fuction setupFetchResultController is not implemented")
        }
        fetchResultsController = conversationListInteractor.setupConversationsFetchedResultController!()
        fetchResultsController.delegate = self
        do {
            try fetchResultsController.performFetch()
        } catch let error {
            print(error)
        }
    }
// TableView functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchResultsController.sections else { return nil }
        return sections[section].name == "1" ? "Online" : "History"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        let userConversation = fetchResultsController.object(at: indexPath)
        cell.name = userConversation.user?.name
        cell.message = userConversation.lastMsg?.messageText
        cell.date = userConversation.date
        cell.hasUnreadMessages = userConversation.hasUnreadMessages
        cell.online = userConversation.isOnline
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showChat", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat", let indexPath = sender as? IndexPath {
            guard let conversationVC = segue.destination as? ConversationViewController else { return }
            let userConversation = fetchResultsController.object(at: indexPath)
            conversationVC.userConversation = userConversation
            conversationVC.conversationInteractor = assembly.getConversationInteractor()
            conversationVC.assembly = assembly
        } else if segue.identifier == "showProfile" {
            guard let navigationVC = segue.destination as? UINavigationController, let profileVC = navigationVC.topViewController as? ProfileViewController else { return }
            profileVC.profileInteractor = assembly.getProfileInteractor()
            profileVC.assembly = assembly
        }
    }
 // Themes block
    @IBAction func themesTappedSwift(_ sender: Any) {
        guard let themesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemesViewControllerSwift") as? ThemesViewControllerSwift else { return }
        if UserDefaults.standard.color(forKey: "theme") == nil {
            themesVC.navigationController?.navigationBar.backgroundColor = .white
            themesVC.view.backgroundColor = .yellow
        }
        themesVC.onChangeTheme = changeThemeWithClosure
    }
    lazy var changeThemeWithClosure: (UIColor) -> Void = { [weak self] (theme: UIColor) in
        self?.logThemeChanging(selectedTheme: theme)
    }
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
    func logThemeChanging(selectedTheme: UIColor) {
        print(selectedTheme)
    }

}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            tableView.reloadRows(at: [newIndexPath!], with: .none)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        case.move:
            tableView.deleteRows(at: [indexPath!], with: .none)
            tableView.insertRows(at: [newIndexPath!], with: .none)
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .none)
        case .delete:
            tableView.deleteSections(indexSet, with: .none)
        case .update:
            tableView.reloadSections(indexSet, with: .none)
        default:
            return
        }
    }
}
