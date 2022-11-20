//
//  TalkViewController.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import UIKit

final class TalkViewController: UIViewController {
    var presenter: TalkViewOutput?
    
    private let tableView = UITableView()
    private let adapter = TalkTableAdapter()
    private let label = UILabel()
    private let errorLabel = UILabel()
    private let speakButton = UIButton()
    private let disconnectButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewLoaded()
    }
}

extension TalkViewController: TalkViewInput {
    func showConnectedPeers(_ connectedPeers: [ConnectedUser]) {
        adapter.updateItems(connectedPeers)
    }
    
    func setSpeakButtonEnabled(_ enabled: Bool) {
        speakButton.isEnabled = enabled
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
    }
    
    func hideError() {
        errorLabel.text = ""
    }
}

private extension TalkViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Talking App"
        navigationItem.hidesBackButton = true
        
        setupSpeakButton()
        setupDisconnectButton()
        setupLabel()
        setupTableView()
        setupErrorLabel()
    }
    
    func setupTableView() {
        view.addSubviewWithMargins(tableView, left: 16, right: 16)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
        ])
        
        tableView.separatorStyle = .none
        
        adapter.setup(for: tableView)
    }
    
    func setupLabel() {
        label.text = "Connected Users:"
        label.textAlignment = .center
        
        view.addSubviewWithMargins(label, left: 16, right: 16)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: disconnectButton.bottomAnchor, constant: 16)
        ])
    }
    
    func setupErrorLabel() {
        view.addSubviewWithMargins(errorLabel, left: 16, right: 16)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            errorLabel.bottomAnchor.constraint(equalTo: speakButton.topAnchor, constant: -16)
        ])
    }
    
    func setupDisconnectButton() {
        disconnectButton.setTitle("Disconnect", for: .normal)
        disconnectButton.setTitleColor(.white, for: .normal)
        disconnectButton.backgroundColor = .black
        disconnectButton.layer.cornerRadius = 8
        
        view.addSubviewWithSafeAreaMargins(disconnectButton, top: 16, left: 16, right: 16)
        NSLayoutConstraint.activate([
            disconnectButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        disconnectButton.addTarget(self, action: #selector(disconnectButtonTapped), for: .touchUpInside)
    }
    
    func setupSpeakButton() {
        speakButton.setTitle("Tap to speak", for: .normal)
        speakButton.setTitleColor(.white, for: .normal)
        speakButton.backgroundColor = .black
        speakButton.layer.cornerRadius = 8
        speakButton.isEnabled = false
        
        view.addSubviewWithSafeAreaMargins(speakButton, left: 16, bottom: 16, right: 16)
        NSLayoutConstraint.activate([
            speakButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleSpeakButtonPress(_:)))
        speakButton.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func disconnectButtonTapped() {
        presenter?.disconnectButtonPressed()
    }
    
    @objc func handleSpeakButtonPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            presenter?.handleButtonPressed()
            speakButton.setTitle("Speaking", for: .normal)
        case .ended, .cancelled:
            presenter?.handleButtonReleased()
            speakButton.setTitle("Press to speak", for: .normal)
        default:
            break
        }
    }
}
