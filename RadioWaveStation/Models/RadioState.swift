//
//  RadioState.swift
//  RadioWaveStation
//
//  Created by Rafli Ramadhan on 31/08/26.
//

import Foundation

enum AudioEffectType: String, CaseIterable {
    case underwater = "Underwater"
    case reverb = "Reverb"
    case delay = "Delay"
}

enum PowerState {
    case on
    case off
}
