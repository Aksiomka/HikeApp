//
//  TalkModuleAssembly.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import UIKit

typealias TalkModuleComponents = (
    view: UIViewController,
    output: TalkModuleOutput
)

enum TalkModuleAssembly {
    static func makeModule(connectionMode: ConnectionMode) -> TalkModuleComponents {
        let view = TalkViewController()
        let presenter = TalkPresenter(connectionMode: connectionMode)
        presenter.view = view
        view.presenter = presenter
        return (view, presenter)
    }
}
