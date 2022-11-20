//
//  TalkPresenter.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import CoreLocation
import Foundation
import MultipeerConnectivity

final class TalkPresenter: TalkModuleOutput {
    weak var view: TalkViewInput?
    
    var onShowMCBrowser: ((MCBrowserViewController) -> Void)?
    var onDisconnected: (() -> Void)?
    
    private let connectionMode: ConnectionMode
    private let connectionManager: ConnectionManager
    private let locationManager: LocationManager
    private let audioManager: AudioManager
    
    private var locationSendingTimer: Timer?
    private var connectedPeers: Set<String> = []
    private var peerDistancesDict = [String: Double]()
    
    init(
        connectionMode: ConnectionMode,
        connectionManager: ConnectionManager = ConnectionManager(),
        locationManager: LocationManager = LocationManager(),
        audioManager: AudioManager = AudioManager()
    ) {
        self.connectionMode = connectionMode
        self.connectionManager = connectionManager
        self.audioManager = audioManager
        self.locationManager = locationManager
        
        locationManager.onLocationServicesDisabled = { [weak self] in
            self?.view?.showError("Location services error occured. Please give access to your location in Settings")
        }
        
        connectionManager.onDataReceived = { [weak self] data, peerName in
            self?.processReceivedData(data, peerName: peerName)
        }
        connectionManager.onShowMCBrowser = { [weak self] vc in
            self?.onShowMCBrowser?(vc)
        }
        connectionManager.onPeerConnected = { [weak self] peerName in
            guard let self = self else { return }
            
            self.connectedPeers.insert(peerName)
            self.updateConnectedUsers()
            
            if self.connectedPeers.count == 1 {
                self.startSendingLocation()
            }
        }
        connectionManager.onPeerDisconnected = { [weak self] peerName in
            guard let self = self else { return }
            
            self.connectedPeers.remove(peerName)
            self.peerDistancesDict.removeValue(forKey: peerName)
            self.updateConnectedUsers()
            
            if self.connectedPeers.isEmpty {
                self.stopSendingLocation()
            }
        }
        
        audioManager.onMicDataCaptured = { [weak self] data in
            do {
                try self?.connectionManager.sendData(data: data)
                self?.view?.hideError()
            } catch {
                self?.view?.showError("Error occured: \(error.localizedDescription)")
            }
        }
    }
}

extension TalkPresenter: TalkViewOutput {
    func viewLoaded() {
        connectionManager.setup()
        locationManager.setup()
        try? audioManager.setup()
        
        switch connectionMode {
        case .host:
            connectionManager.startHosting()
        case .join:
            connectionManager.joinSession()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func handleButtonPressed() {
        audioManager.changeMicState(.on)
    }
    
    func handleButtonReleased() {
        audioManager.changeMicState(.off)
    }
    
    func disconnectButtonPressed() {
        locationManager.stopUpdatingLocation()
        connectionManager.disconnect()
        stopSendingLocation()
        onDisconnected?()
    }
}

private extension TalkPresenter {
    func startSendingLocation() {
        locationSendingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(locationTimerFired), userInfo: nil, repeats: true)
    }
    
    func stopSendingLocation() {
        locationSendingTimer?.invalidate()
        locationSendingTimer = nil
    }
    
    func peerLocationUpdated(peerName: String, peerLocation: CLLocationCoordinate2D) {
        guard let currentLocation = locationManager.currentLocation else {
            return
        }
        
        let distance = DistanceCalculator().calcDistanceBetween(currentLocation, and: peerLocation)
        peerDistancesDict[peerName] = distance
        
        let users = peerDistancesDict.map { ConnectedUser(name: $0.key, distance: $0.value) }
        view?.showConnectedPeers(users)
    }
    
    @objc func locationTimerFired() {
        guard let currentLocation = locationManager.currentLocation else {
            return
        }
        
        do {
            try connectionManager.sendData(data: locationToData(currentLocation))
            view?.hideError()
        } catch {
            view?.showError("Error occured: \(error.localizedDescription)")
        }
    }
    
    func processReceivedData(_ data: Data, peerName: String) {
        if !connectedPeers.contains(peerName) {
            self.connectedPeers.insert(peerName)
            self.updateConnectedUsers()
            
            if self.connectedPeers.count == 1 {
                self.startSendingLocation()
            }
        }
        
        if data.count == MemoryLayout<CLLocationCoordinate2D>.size {
            guard let currentLocation = locationManager.currentLocation else { return }
            
            let peerLocation = dataToLocation(data)
            let distance = DistanceCalculator().calcDistanceBetween(currentLocation, and: peerLocation)
            peerDistancesDict[peerName] = distance
            updateConnectedUsers()
        } else {
            audioManager.playData(data: data)
        }
    }
    
    func locationToData(_ location: CLLocationCoordinate2D) -> Data {
        var location = location
        return Data(bytes: &location, count: MemoryLayout<CLLocationCoordinate2D>.size)
    }
    
    func dataToLocation(_ data: Data) -> CLLocationCoordinate2D {
        return data.withUnsafeBytes {
            $0.load(as: CLLocationCoordinate2D.self)
        }
    }
    
    func updateConnectedUsers() {
        let users = peerDistancesDict.map { ConnectedUser(name: $0.key, distance: $0.value) }
        view?.showConnectedPeers(users)
        
        updateSpeakButtonState()
    }
    
    func updateSpeakButtonState() {
        let enabled = !connectedPeers.isEmpty
        view?.setSpeakButtonEnabled(enabled)
    }
}
