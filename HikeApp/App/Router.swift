//
//  Router.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import UIKit

final class Router {
    var topNavigationController: UINavigationController? {
        let topViewController = UIApplication.topViewController()
        return topViewController as? UINavigationController ?? topViewController?.navigationController
    }
    
    func showModeSelection() -> ModeModuleComponents {
        let module = ModeModuleAssembly.makeModule()
        topNavigationController?.setViewControllers([module.view], animated: false)
        return module
    }
    
    func showTalk(connectionMode: ConnectionMode) -> TalkModuleComponents {
        let module = TalkModuleAssembly.makeModule(connectionMode: connectionMode)
        topNavigationController?.pushViewController(module.view, animated: true)
        return module
    }
    
    func presentViewController(_ viewController: UIViewController) {
        topNavigationController?.present(viewController, animated: true)
    }
    
    func closeModule() {
        topNavigationController?.popViewController(animated: true)
    }
    
    func dismissModule() {
        UIApplication.topViewController()?.dismiss(animated: true)
    }
}
