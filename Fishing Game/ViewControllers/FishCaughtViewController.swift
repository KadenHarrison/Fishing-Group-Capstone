//
//  FishCaughtViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/13/25.
//

import UIKit

class FishCaughtViewController: UIViewController {
    
    // Gets the fish you caught and from that gets the according image and fill the labels in
    var fish: Fish?
    
    // MARK: The outlets connecting to storyboard
    @IBOutlet weak var fishDisplayImageView: UIImageView!
    
    @IBOutlet weak var fishNameLabel: UILabel!
    @IBOutlet weak var fishSizeLabel: UILabel!
    @IBOutlet weak var fishRarityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Handle errors if fish is nil
        guard let fish else { return }
        
        
        /// Setting the elements for the fish caught screen
        // Set the image for the fish
        fishDisplayImageView.image = fish.image
        
        fishNameLabel.text = "You caught a \(fish.type.rawValue.capitalized)!"
        fishSizeLabel.text = "Size: \(fish.size.rounded(toPlaces: 2)) inches"
        fishRarityLabel.text = "Rarity: \(fish.rarity.rawValue.capitalized)"
    }
    @IBAction func nextButton(_ sender: Any) {
        SoundManager.shared.playSound(named: "bubble4")
    }
}
