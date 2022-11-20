//
//  UIView+Extension.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 16.11.2022.
//

import UIKit

extension UIView {
    func addSubviewWithMargins(
        _ subview: UIView,
        top: CGFloat? = nil,
        left: CGFloat? = nil,
        bottom: CGFloat? = nil,
        right: CGFloat? = nil
    ) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        var constraints = [NSLayoutConstraint]()
        if let top = top {
            constraints.append(subview.topAnchor.constraint(equalTo: topAnchor, constant: top))
        }
        if let left = left {
            constraints.append(subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left))
        }
        if let bottom = bottom {
            constraints.append(subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom))
        }
        if let right = right {
            constraints.append(subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -right))
        }
        if !constraints.isEmpty {
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func addSubviewWithSafeAreaMargins(
        _ subview: UIView,
        top: CGFloat? = nil,
        left: CGFloat? = nil,
        bottom: CGFloat? = nil,
        right: CGFloat? = nil
    ) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        var constraints = [NSLayoutConstraint]()
        if let top = top {
            constraints.append(subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: top))
        }
        if let left = left {
            constraints.append(subview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: left))
        }
        if let bottom = bottom {
            constraints.append(subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -bottom))
        }
        if let right = right {
            constraints.append(subview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -right))
        }
        if !constraints.isEmpty {
            NSLayoutConstraint.activate(constraints)
        }
    }
}
