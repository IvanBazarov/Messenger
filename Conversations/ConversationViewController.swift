//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Иван Базаров on 07.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userConversation: Conversation!
    var fetchResultsController: NSFetchedResultsController<Message>!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var sendMessageTextView: UITextField!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if let text = sendMessageTextView.text, let conversationId = userConversation.convID {
        CommunicationManager.shared.communicator?.sendMessage(string: text, to: conversationId) { succes, error in
            if succes {
                self.sendMessageTextView.text = ""
                self.sendButton.isEnabled = false
            }
            if let error = error {
                print(error.localizedDescription)
                self.view.endEditing(true)
                let alert = UIAlertController(title: "Ошибка при отправке сообщения", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
      }
    }
    @IBAction func messageViewChanged(_ sender: Any) {
        if sendMessageTextView.text == "" {
            sendButton.isEnabled = false
        } else if userConversation.isOnline {
            sendButton.isEnabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        CommunicationManager.shared.delegate = self
        setupViews()
        setupKeyboardFrame()
        setupFRC()
    }
    private func setupFRC() {
        guard let conversationID = userConversation.convID else { return }
        fetchResultsController = NSFetchedResultsController(fetchRequest: FetchRequestsManager.shared.fetchMessagesFrom(conversationID: conversationID), managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        do {
            try fetchResultsController.performFetch()
        } catch {
        }
    }
    func setupViews() {
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        self.sendButton.imageView?.contentMode = .scaleAspectFit
        self.sendButton.imageEdgeInsets = UIEdgeInsets.init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
    func setupKeyboardFrame() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(gesture:)))
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToLastRow()
        sendButton.clipsToBounds = true
        sendButton.isEnabled = false
        userConversation.hasUnreadMessages = false
    }
    @objc func hideKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        bottomConstraint.constant = keyboardSize.height + 5 - view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
            self.scrollToLastRow()
        }
    }
    @objc private func keyboardWillHidden() {
        self.bottomConstraint.constant = 7
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }
    func scrollToLastRow() {
        guard let fetchedObjects = fetchResultsController.fetchedObjects else { return }
        if !fetchedObjects.isEmpty {
            let indexPath = IndexPath(row: fetchedObjects.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    // Table View setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchResultsController.sections else { return 0 }
    return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseIdentifier: String
        var cell: ChatTableViewCell
        let message = fetchResultsController.object(at: indexPath)
        if message.isIncoming {
            reuseIdentifier = "incomingMsgCell"
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatTableViewCell
            cell.msg = message.messageText
        } else {
            reuseIdentifier = "outgoingMsgCell"
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatTableViewCell
            cell.msg = message.messageText
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ConversationViewController: CommunicationDelegate {
    func updateUserData() {
        if !userConversation.isOnline {
            sendButton.isEnabled = false
        }
        userConversation.hasUnreadMessages = false
        tableView.reloadData()
        scrollToLastRow()
    }
    func handleError(error: Error) {
        self.view.endEditing(true)
        let alertController = UIAlertController(title: "Connection Problem", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateUserData()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .none)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .none)
            tableView.insertRows(at: [newIndexPath!], with: .none)
        }
    }
}
