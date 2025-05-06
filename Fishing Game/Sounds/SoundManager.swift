//
//  SoundManager.swift
//  Fishing Game
//
//  Created by Kaden Harrison on 5/5/25.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    private var reelPlayer: AVAudioPlayer? // For reel-only sound

    private init() {}

    func playSound(named name: String, withExtension ext: String = "mp3") {
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Failed to play sound: \(error)")
            }
        }
    }

    func startReelSound() {
        guard let url = Bundle.main.url(forResource: "reelSound", withExtension: "mp3") else { return }
        do {
            reelPlayer = try AVAudioPlayer(contentsOf: url)
            reelPlayer?.numberOfLoops = -1 // loop until stopped
            reelPlayer?.play()
        } catch {
            print("Failed to start reel sound: \(error)")
        }
    }

    func stopReelSound() {
        reelPlayer?.stop()
        reelPlayer = nil
    }
}
