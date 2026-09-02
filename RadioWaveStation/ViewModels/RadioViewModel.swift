//
//  RadioViewModel.swift
//  RadioWaveStation
//
//  Created by Rafli Ramadhan on 31/08/26.
//

import Foundation
import SwiftUI
import Combine

class RadioViewModel: ObservableObject {
    @Published var isPowerOn: Bool = false
    @Published var volume: Double = 0.5
    @Published var effectMix: Double = 0.5
    
    @Published var isUnderwaterOn: Bool = false
    @Published var isReverbOn: Bool = false
    @Published var isDelayOn: Bool = false
    
    private let audioManager = AudioPlayerManager.shared
    
    func togglePower() {
        isPowerOn.toggle()
        if !isPowerOn {
            resetEffects()
        } else {
            audioManager.togglePlay()
            audioManager.resetAllEffects()
        }
    }
    func toggleEffect(_ type: AudioEffectType) {
        guard isPowerOn else { return }
        
        switch type {
        case .underwater:
            isUnderwaterOn.toggle()
            audioManager.applyEffect(type: .underwater, isOn: isUnderwaterOn)
        case .reverb:
            isReverbOn.toggle()
            audioManager.applyEffect(type: .reverb, isOn: isReverbOn)
        case .delay:
            isDelayOn.toggle()
            audioManager.applyEffect(type: .delay, isOn: isDelayOn)
        }
    }
    
    func updateVolume(to value: Double) {
        volume = min(max(0.0, value), 1.0)
        audioManager.setVolume(Float(volume))
    }
    
    func updateEffectMix(to value: Double) {
        effectMix = min(max(0.0, value), 1.0)
        print("Effect Mix: \(Int(effectMix * 100))%")
    }
    
    var powerImageName: String {
        return isPowerOn ? "TombolOn" : "TombolOff"
    }
    
    func isEffectActive(_ type: AudioEffectType) -> Bool {
        switch type {
        case .underwater: return isUnderwaterOn
        case .reverb: return isReverbOn
        case .delay: return isDelayOn
        }
    }
    
    func effectImageName(for type: AudioEffectType) -> String {
        let isActive = isEffectActive(type)
        let baseName: String
        
        switch type {
        case .underwater: baseName = "UnderwaterEffect"
        case .reverb: baseName = "ReverbEffect"
        case .delay: baseName = "DelayEffect"
        }

        return isActive ? "\(baseName)On" : baseName
    }
    
    
    private func resetEffects() {
        isUnderwaterOn = false
        isReverbOn = false
        isDelayOn = false
    }
    
    
}
