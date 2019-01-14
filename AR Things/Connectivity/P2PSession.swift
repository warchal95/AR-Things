//
//  P2PSession.swift
//  AR Test
//

import MultipeerConnectivity

final class P2PSession: NSObject {
    
    private struct Constants {
        static let serviceType = "ar-multi-sample"
        static let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    }
    
    /// Array with connected peers
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
    
    private lazy var serviceAdvertiser: MCNearbyServiceAdvertiser = {
        MCNearbyServiceAdvertiser(peer: Constants.myPeerID, discoveryInfo: nil, serviceType: Constants.serviceType)
    }()
    
    private lazy var serviceBrowser: MCNearbyServiceBrowser = {
        MCNearbyServiceBrowser(peer: Constants.myPeerID, serviceType: Constants.serviceType)
    }()
    
    private let receivedDataHandler: (Data, MCPeerID) -> Void
    
    private let session = MCSession(peer: Constants.myPeerID, securityIdentity: nil, encryptionPreference: .required)
    
    /// Initializes class with given handler
    ///
    /// - Parameter receivedDataHandler: Handler of the p2p session
    init(receivedDataHandler: @escaping (Data, MCPeerID) -> Void ) {
        self.receivedDataHandler = receivedDataHandler
        super.init()
        setupProperties()
    }
    
    /// Sends data to all connected peers
    ///
    /// - Parameter data: Data that should be sent
    func send(_ data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("error sending data to peers: \(error.localizedDescription)")
        }
    }
    
    private func setupProperties() {
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
}

/// - SeeAlso: MCSessionDelegate
extension P2PSession: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedDataHandler(data, peerID)
    }
    
    /// No need of implementation
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) { }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
}

/// - SeeAlso: MCNearbyServiceBrowserDelegate
extension P2PSession: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        // Invite the new peer to the session.
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    /// No need of implementation
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }
}

/// - SeeAlso: MCNearbyServiceAdvertiserDelegate
extension P2PSession: MCNearbyServiceAdvertiserDelegate {
    
    /// Accept Invite
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Calls handler to accept invitation and join the session.
        invitationHandler(true, session)
    }
}
