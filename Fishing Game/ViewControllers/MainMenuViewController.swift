//
//  MainMenuViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/7/25.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TackleboxService.shared.load()
        // Do any additional setup after loading the view.
    }
    @IBAction func gameStartButton(_ sender: Any) {
        SoundManager.shared.playSound(named: "bubble4")
    }
    @IBAction func settingButton(_ sender: Any) {
        SoundManager.shared.playSound(named: "bubble2")
    }
    
}
