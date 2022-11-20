//
//  AudioManager.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import Foundation
import AVFoundation

final class AudioManager {
    enum MicState {
        case on
        case off
    }
    
    var onMicDataCaptured: ((Data) -> Void)?
    
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private let audioPlayer = AVAudioPlayerNode()
    private let mixerNode = AVAudioMixerNode()
    
    private var playerCofigured = false
    private let incomingFormat: AVAudioFormat
    private let audioSession = AVAudioSession.sharedInstance()
    
    init() {
        inputNode = audioEngine.inputNode
        incomingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
    }

    func setup() throws {
        try setupAudioSession()
        try initAudioEngine()
        try audioEngine.start()
    }
    
    func changeMicState(_ state: MicState) {
        switch state {
        case .on:
            mixerNode.installTap(
                onBus: 0,
                bufferSize: 8192,
                format: audioEngine.inputNode.outputFormat(forBus: 0)
            ) { [weak self] buffer, audioTime in
                self?.processMicData(buffer: buffer, timeE: audioTime)
            }
        case .off:
            mixerNode.removeTap(onBus: 0)
        }
    }
    
    func playData(data: Data) {
        if data.count > 0 && playerCofigured && audioEngine.isRunning {
            if let buffer = toPCMBuffer(data: data as NSData) {
                audioPlayer.scheduleBuffer(buffer, completionHandler: nil)
                audioPlayer.prepare(withFrameCount: buffer.frameCapacity)
                audioPlayer.play()
            }
        } else {
            audioPlayer.stop()
        }
    }
}

private extension AudioManager {
    func setupAudioSession() throws {
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try audioSession.overrideOutputAudioPort(.speaker)
        try audioSession.setActive(true)
    }
    
    func initAudioEngine() throws {
        if !playerCofigured {
            setupMicInput()
            try setupLocalOutput()
        }
        
        if !audioEngine.isRunning {
            audioEngine.prepare()
        }
    }
    
    func setupLocalOutput() throws {
        let inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        
        mixerNode.volume = 0.0
        
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.attach(mixerNode)
        audioEngine.connect(audioEngine.inputNode, to: mixerNode, format: inputFormat)
        audioEngine.connect(mixerNode, to: mainMixer, format: audioEngine.inputNode.outputFormat(forBus: 0))
        
        try audioEngine.start()
    }
    
    func setupMicInput() {
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.attach(audioPlayer)
        audioEngine.connect(audioPlayer, to: mainMixer, format: audioEngine.inputNode.outputFormat(forBus: 0))
        playerCofigured = true
    }
    
    func processMicData(buffer: AVAudioPCMBuffer, timeE: AVAudioTime) {
        buffer.frameLength = 8192
        let data = toData(PCMBuffer: buffer)
        DispatchQueue.main.async { [weak self] in
            self?.onMicDataCaptured?(data)
        }
    }
    
    func toData(PCMBuffer: AVAudioPCMBuffer) -> Data {
        let channelCount = 1
        let channels = UnsafeBufferPointer(start: PCMBuffer.floatChannelData, count: channelCount)
        
        let ch0Data = NSData(bytes: channels[0], length: Int(PCMBuffer.frameLength *
            PCMBuffer.format.streamDescription.pointee.mBytesPerFrame))
        return ch0Data as Data
    }
    
    func toPCMBuffer(data: NSData) -> AVAudioPCMBuffer? {
        guard
            let pcmBuffer = AVAudioPCMBuffer(
                pcmFormat: incomingFormat,
                frameCapacity: UInt32(data.length) / incomingFormat.streamDescription.pointee.mBytesPerFrame)
        else {
            return nil
        }
        pcmBuffer.frameLength = pcmBuffer.frameCapacity
        
        let channels = UnsafeBufferPointer(
            start: pcmBuffer.floatChannelData,
            count: Int(pcmBuffer.format.channelCount)
        )
        data.getBytes(UnsafeMutableRawPointer(channels[0]), length: data.length)
        return pcmBuffer
    }
}
