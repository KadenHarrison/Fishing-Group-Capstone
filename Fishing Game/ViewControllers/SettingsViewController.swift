//
//  SettingsViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/8/25.
//

import UIKit

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func resetGame(_ sender: Any) {
        TackleboxService.shared.reset()
        LocationService.shared.resetToDefaults()
        JournalService.shared.reset()
        
        SoundManager.shared.playSound(sound: .bubble3)
    }
}
