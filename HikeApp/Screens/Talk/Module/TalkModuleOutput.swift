//
//  TalkModuleOutput.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 16.11.2022.
//

import Foundation
import MultipeerConnectivity

protocol TalkModuleOutput: AnyObject {
    var onShowMCBrowser: ((MCBrowserViewController) -> Void)? { get set }
    var onDisconnected: (() -> Void)? { get set }
}
