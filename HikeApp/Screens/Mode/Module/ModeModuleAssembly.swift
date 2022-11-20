//
//  ModeModuleAssembly.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import UIKit

typealias ModeModuleComponents = (
    view: UIViewController,
    output: ModeModuleOutput
)

enum ModeModuleAssembly {
    static func makeModule() -> ModeModuleComponents {
        let view = ModeViewController()
        let presenter = ModePresenter()
        presenter.view = view
        view.presenter = presenter
        return (view, presenter)
    }
}
