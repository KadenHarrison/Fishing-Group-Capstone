//
//  MainMenuViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/7/25.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var startGameButton: UIButton!
    override func viewDidLoad() {
//        startGameButton.setTitle("Hello".localized(), for: .normal)
        super.viewDidLoad()
        TackleboxService.shared.load()
        // Do any additional setup after loading the view.
    }
    @IBAction func gameStartButton(_ sender: Any) {
        SoundManager.shared.playSound(sound: .bubble4)
    }
    @IBAction func settingButton(_ sender: Any) {
        SoundManager.shared.playSound(sound: .bubble2)
    }
    
}



extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Main",
            bundle: .main,
            value: self,
            comment: self)
    }
}
