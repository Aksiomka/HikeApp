//
//  TalkViewOutput.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 16.11.2022.
//

import UIKit

protocol TalkViewOutput: AnyObject {
    func viewLoaded()
    func handleButtonPressed()
    func handleButtonReleased()
    func disconnectButtonPressed()
}
