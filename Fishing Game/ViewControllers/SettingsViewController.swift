//
//  SettingsViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/8/25.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func resetGame(_ sender: Any) {
        Tacklebox.shared = Tacklebox()
        
        Tacklebox.save()
    }
}
