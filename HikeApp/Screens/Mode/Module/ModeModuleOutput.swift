//
//  ModeModuleOutput.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 16.11.2022.
//

import Foundation

protocol ModeModuleOutput: AnyObject {
    var onModeSelected: ((ConnectionMode) -> Void)? { get set }
}
