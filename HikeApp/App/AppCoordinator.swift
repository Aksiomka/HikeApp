//
//  AppCoordinator.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import Foundation
import MultipeerConnectivity

final class AppCoordinator: NSObject {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        showModeSelection()
    }
}

private extension AppCoordinator {
    func showModeSelection() {
        let module = router.showModeSelection()
        module.output.onModeSelected = { [weak self] connectionMode in
            self?.showTalk(connectionMode: connectionMode)
        }
    }
    
    func showTalk(connectionMode: ConnectionMode) {
        let module = router.showTalk(connectionMode: connectionMode)
        module.output.onShowMCBrowser = { [weak self] vc in
            self?.showMCBrowserViewController(vc)
        }
        module.output.onDisconnected = { [weak self] in
            self?.router.closeModule()
        }
    }
    
    func showMCBrowserViewController(_ viewController: MCBrowserViewController) {
        viewController.delegate = self
        router.presentViewController(viewController)
    }
}

extension AppCoordinator: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        router.dismissModule()
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        router.dismissModule()
    }
}
