//
//  TalkViewInput.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import UIKit

protocol TalkViewInput: AnyObject {
    func showConnectedPeers(_ connectedPeers: [ConnectedUser])
    func setSpeakButtonEnabled(_ enabled: Bool)
    func showError(_ message: String)
    func hideError()
}
