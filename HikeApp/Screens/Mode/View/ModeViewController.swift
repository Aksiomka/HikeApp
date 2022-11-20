//
//  ModeViewController.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 11.11.2022.
//

import UIKit

final class ModeViewController: UIViewController {
    var presenter: ModeViewOutput?
    
    private let label = UILabel()
    private let hostButton = UIButton()
    private let joinButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension ModeViewController: ModeViewInput {}

private extension ModeViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Talking App"
        
        setupButton(button: hostButton, title: "Be a host", centerYOffset: -40)
        setupButton(button: joinButton, title: "Join existing session", centerYOffset: 40)
        setupLabel()
        
        hostButton.addTarget(self, action: #selector(hostButtonTapped), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    func setupButton(button: UIButton, title: String, centerYOffset: CGFloat) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        
        view.addSubviewWithMargins(button, left: 16, right: 16)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: centerYOffset),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupLabel() {
        label.text = "Select mode"
        label.textAlignment = .center
        
        view.addSubviewWithMargins(label, left: 16, right: 16)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: hostButton.topAnchor, constant: -40),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func hostButtonTapped() {
        presenter?.hostButtonTapped()
    }
    
    @objc func joinButtonTapped() {
        presenter?.joinButtonTapped()
    }
}
