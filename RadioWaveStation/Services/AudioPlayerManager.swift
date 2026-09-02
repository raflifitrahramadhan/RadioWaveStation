//
//  AudioPlayerManager.swift
//  RadioWaveStation
//
//  Created by Rafli Ramadhan on 01/09/26.
//

import Foundation
import AVFoundation
import Combine



class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()
    
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    
    private let eqNode = AVAudioUnitEQ(numberOfBands: 1) 
    private let reverbNode = AVAudioUnitReverb()
    private let delayNode = AVAudioUnitDelay()
    
    private var audioFile: AVAudioFile?
    private var isPlaying = false
    
    private init() {
        setupAudioSession()
        setupAudioGraph()
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {

            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Audio Session Error: \(error)")
        }
    }

    private func setupAudioGraph() {
        // Attach nodes ke engine
        engine.attach(playerNode)
        engine.attach(eqNode)
        engine.attach(reverbNode)
        engine.attach(delayNode)
        

        if let fileURL = Bundle.main.url(forResource: "BryanAdams-Heaven", withExtension: "mp3") {
            audioFile = try? AVAudioFile(forReading: fileURL)
        }
        
        guard let format = audioFile?.processingFormat else { return }
        
        engine.connect(playerNode, to: eqNode, format: format)
        engine.connect(eqNode, to: reverbNode, format: format)
        engine.connect(reverbNode, to: delayNode, format: format)
        engine.connect(delayNode, to: engine.mainMixerNode, format: format)
        
        configureEffects()
    }
    
    func togglePlay() {
        if isPlaying {
            playerNode.stop()
            isPlaying = false
        } else {
            guard let file = audioFile else { return }
            playerNode.scheduleFile(file, at: nil)
            do {
                try engine.start()
                playerNode.play()
                isPlaying = true
            } catch {
                print("Error playing audio: \(error)")
            }
        }
    }
    
    func setVolume(_ value: Float) {
        playerNode.volume = value
    }
    

    func applyEffect(type: AudioEffectType, isOn: Bool) {
        switch type {
        case .underwater:
            
            let filter = eqNode.bands[0]
            filter.filterType = .lowPass
            filter.frequency = isOn ? 800 : 20000
            filter.bypass = !isOn
        case .reverb:
            reverbNode.loadFactoryPreset(.largeHall)
            reverbNode.wetDryMix = isOn ? 50 : 0
        case .delay:
            delayNode.delayTime = 0.5
            delayNode.feedback = 50
            delayNode.wetDryMix = isOn ? 30 : 0
        }
    }
    
    func resetAllEffects() {
        eqNode.bands[0].bypass = true
        reverbNode.wetDryMix = 0
        delayNode.wetDryMix = 0
    }

    private func configureEffects() {
        
        eqNode.bands[0].bypass = true
        reverbNode.wetDryMix = 0
        delayNode.wetDryMix = 0
    }
}
