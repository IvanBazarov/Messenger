//
//  MCExtension.swift
//  Messenger
//
//  Created by Иван Базаров on 28.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("Current state for session with \(peerID.displayName) is not connected")
        case .connecting:
            print("Current state for session with \(peerID.displayName) is connecting")
        case .connected:
            print("Current state for session with \(peerID.displayName) is connected")
        }
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { print(#function) }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { print(#function) }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { print(#function)}
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let jsonDecoder = JSONDecoder()
        guard let info = try? jsonDecoder.decode([String:String].self, from: data), info["eventType"] == "TextMessage" else { return }
        delegate?.didReceiveMessage(text: info["text"]!, fromUser: peerID.displayName, toUser: myPeerId.displayName)
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let info = info, let userName = info["userName"] else { return }
        let session: MCSession = getSession(with: peerID)
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        delegate?.didFoundUser(userId: peerID.displayName, userName: userName)
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        sessionsDictionary.removeValue(forKey: peerID.displayName)
        delegate?.didLostUser(userId: peerID.displayName)
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToBrowseUsers(error: error)
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToAdvertise(error: error)
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let session = getSession(with: peerID)
        invitationHandler(true, session)
    }
}
