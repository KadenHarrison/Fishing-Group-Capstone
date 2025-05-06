//
//  OutOfBaitViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/9/25.
//

import UIKit

class OutOfBaitViewController: UIViewController {

    var caughtFish: [Fish] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SummaryScreenViewController else { return }
        
        destination.caughtFish = caughtFish
    }
    
    @IBAction func goHomeEarlyButton(_ sender: Any) {
        SoundManager.shared.playSound(sound: .bubble1)
    }
}
