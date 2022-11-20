//
//  ModePresenter.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 11.11.2022.
//

import Foundation

final class ModePresenter: ModeModuleOutput {
    weak var view: ModeViewInput?
    
    var onModeSelected: ((ConnectionMode) -> Void)?
}

extension ModePresenter: ModeViewOutput {
    func hostButtonTapped() {
        onModeSelected?(.host)
    }
    
    func joinButtonTapped() {
        onModeSelected?(.join)
    }
}
