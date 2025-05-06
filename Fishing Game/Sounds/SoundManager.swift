//
//  SoundManager.swift
//  Fishing Game
//
//  Created by Kaden Harrison on 5/5/25.
//

import Foundation
import AVFoundation

enum Sound: String {
    case bubble1, bubble2, bubble3, bubble4, bubbleEngine
}

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playSound(sound: Sound, withExtension ext: String = "mp3") {
        if let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ext) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Failed to play sound: \(error)")
            }
        }
    }

}
