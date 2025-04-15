//
//  FishCaughtViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/13/25.
//

import UIKit

class FishCaughtViewController: UIViewController {
    
    var fish: Fish?
    
    @IBOutlet weak var fishDisplayImageView: UIImageView!
    
    @IBOutlet weak var fishNameLabel: UILabel!
    @IBOutlet weak var fishSizeLabel: UILabel!
    @IBOutlet weak var fishRarityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Handle errors if fish is nil
        guard let fish else { return }
        
        fishDisplayImageView.image = fish.image
        
        fishNameLabel.text = "You caught a \(fish.type.rawValue.capitalized)!"
        fishSizeLabel.text = "Size: \(fish.size.rounded(toPlaces: 2)) inches"
        fishRarityLabel.text = "Rarity: \(fish.rarity.rawValue.capitalized)"
    }

}
