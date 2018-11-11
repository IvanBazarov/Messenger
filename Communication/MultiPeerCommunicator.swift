//
//  MultiPeerCommunicator.swift
//  Messenger
//
//  Created by Иван Базаров on 28.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    var myPeerId: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var sessionsDictionary: [String: MCSession] = [:]
    weak var delegate: CommunicatorDelegate?
    var online: Bool = true {
        didSet {
            if online {
                browser.startBrowsingForPeers()
                advertiser.startAdvertisingPeer()
            } else {
                browser.stopBrowsingForPeers()
                advertiser.stopAdvertisingPeer()
            }
        }
    }
    init(profile: UserProfile) {
        super.init()
        myPeerId = MCPeerID(displayName: UIDevice.current.name)
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: "tinkoff-chat")
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName" : profile.name], serviceType: "tinkoff-chat")
        browser.delegate = self
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    func sendMessage(string: String, to userId: String, completionHandler: messageHandler?) {
        guard let session = sessionsDictionary[userId] else { return }
        let dictionaryToSend = ["eventType" : "TextMessage", "messageId" : generateMessageId(), "text" : string]
        guard let data = try? JSONSerialization.data(withJSONObject: dictionaryToSend, options: .prettyPrinted) else { return }
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            delegate?.didReceiveMessage(text: string, fromUser: myPeerId.displayName, toUser: userId)
            if let completion = completionHandler {
                completion(true, nil)
            }
        } catch let error {
            if let completion = completionHandler {
                completion(false, error)
            }
        }
    }
    func getSession(with peerID: MCPeerID) -> MCSession {
        guard sessionsDictionary[peerID.displayName] == nil else { return sessionsDictionary[peerID.displayName]! }
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessionsDictionary[peerID.displayName] = session
        return sessionsDictionary[peerID.displayName]!
    }
    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
