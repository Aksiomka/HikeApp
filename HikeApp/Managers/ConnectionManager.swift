//
//  ConnectionManager.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import Foundation
import MultipeerConnectivity

final class ConnectionManager: NSObject {
    private enum Constants {
        static let serviceType = "hws-kb"
    }
    
    var onDataReceived: ((Data, String) -> Void)?
    var onShowMCBrowser: ((MCBrowserViewController) -> Void)?
    var onPeerConnected: ((String) -> Void)?
    var onPeerDisconnected: ((String) -> Void)?
    
    private var peerID: MCPeerID!
    private var mcSession: MCSession!
    private var mcAdvertiserAssistant: MCAdvertiserAssistant!
    private var connectionMode: ConnectionMode = .host
    
    func setup() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession.delegate = self
    }
    
    func startHosting() {
        connectionMode = .host
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: Constants.serviceType, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        print("Advertising started")
    }

    func joinSession() {
        connectionMode = .join
        let mcBrowserViewController = MCBrowserViewController(serviceType: Constants.serviceType, session: mcSession)
        onShowMCBrowser?(mcBrowserViewController)
    }
    
    func sendData(data: Data) throws {
        if mcSession.connectedPeers.count > 0 {
            try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
        }
    }
    
    func disconnect() {
        if connectionMode == .host {
            mcAdvertiserAssistant.stop()
        }
        mcSession.disconnect()
        print("Disconnected")
    }
}

extension ConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async { [weak self] in
                self?.onPeerConnected?(peerID.displayName)
            }
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async { [weak self] in
                self?.onPeerDisconnected?(peerID.displayName)
            }
        @unknown default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            self?.onDataReceived?(data, peerID.displayName)
            print("Data received for \(peerID.displayName)")
        }
    }
}
