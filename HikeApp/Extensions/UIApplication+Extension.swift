//
//  UIApplication+Extension.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 16.11.2022.
//

import UIKit

extension UIApplication {
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows
            .first(where: { $0.isKeyWindow })
    }
    
    static func topViewController(_ controller: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController,
           let visibleController = navigationController.visibleViewController {
            return topViewController(visibleController)
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }
        
        return controller
    }
}
