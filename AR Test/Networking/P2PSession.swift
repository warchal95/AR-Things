//
//  P2PSession.swift
//  AR Test
//

import MultipeerConnectivity

final class P2PSession: NSObject {
    
    struct Constants {
        static let serviceType = "ar-multi-sample"
        static let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    }
    
    private lazy var serviceAdvertiser: MCNearbyServiceAdvertiser = {
        MCNearbyServiceAdvertiser(peer: Constants.myPeerID, discoveryInfo: nil, serviceType: Constants.serviceType)
    }()
    
    private lazy var serviceBrowser: MCNearbyServiceBrowser = {
        MCNearbyServiceBrowser(peer: Constants.myPeerID, serviceType: Constants.serviceType)
    }()
    
    private let receivedDataHandler: (Data, MCPeerID) -> Void
    
    internal var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
    
    lazy var session: MCSession = {
        MCSession(peer: Constants.myPeerID, securityIdentity: nil, encryptionPreference: .required)
    }()
    
    /// Init
    init(receivedDataHandler: @escaping (Data, MCPeerID) -> Void ) {
        self.receivedDataHandler = receivedDataHandler
        
        super.init()
        setupProperties()
    }
}

extension P2PSession {
    private func setupProperties() {
        session.delegate = self
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    func sendToAllPeers(_ data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("error sending data to peers: \(error.localizedDescription)")
        }
    }
}

extension P2PSession: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedDataHandler(data, peerID)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) { }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
}

extension P2PSession: MCNearbyServiceBrowserDelegate {
    
    /// Found Peer
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        // Invite the new peer to the session.
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }
    
}

extension P2PSession: MCNearbyServiceAdvertiserDelegate {
    /// Accept Invite
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Call handler to accept invitation and join the session.
        invitationHandler(true, session)
    }
}
