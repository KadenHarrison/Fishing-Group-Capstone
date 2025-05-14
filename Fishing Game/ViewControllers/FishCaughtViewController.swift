//
//  FishCaughtViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/13/25.
//

import UIKit

enum CaughtItem {
    case fish(Fish)
    case junk(Junk)
    
    var price: Double {
        switch self {
        case let .fish(fish):
            return fish.price
        case let .junk(junk):
            return junk.price
        }
    }
    
    var fishType: FishType? {
        switch self {
        case .fish(let fish):
            return fish.type
        case .junk:
            return nil
        }
    }
}

extension [CaughtItem] {
    var caughtFish: [Fish] {
        compactMap { item in
            switch item {
            case .fish(let fish):
                return fish
            case .junk:
                return nil
            }
        }
    }
}

class FishCaughtViewController: UIViewController {
    
    // could be fish or junk depending on what you caught
    var caughtItem: CaughtItem?
    
    // MARK: The outlets connecting to storyboard
    @IBOutlet weak var fishDisplayImageView: UIImageView!
    
    @IBOutlet weak var fishNameLabel: UILabel!
    @IBOutlet weak var fishSizeLabel: UILabel!
    @IBOutlet weak var fishRarityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Handle errors if fish is nil
        guard let caughtItem else { return }
        
        switch caughtItem {
        case let .fish(fish):
            updateUI(with: fish)
        case let .junk(junk):
            updateUI(with: junk)
        }
        
    }
    
    func updateUI(with fish: Fish) {
        /// Setting the elements for the fish caught screen
        // Set the image for the fish
        fishDisplayImageView.image = fish.image
        
        fishNameLabel.text = "You caught a ".localized() + fish.type.rawValue.capitalized.localized() + "!"
        fishSizeLabel.text = "Size: ".localized() + "\(fish.size.rounded(toPlaces: 2)) " + "inches".localized()
        fishRarityLabel.text = "Rarity: ".localized() + fish.rarity.rawValue.capitalized.localized()
    }
    
    func updateUI(with junk: Junk) {
        fishDisplayImageView.image = nil
        
        fishNameLabel.text = "You caught a ".localized() + junk.type.rawValue.capitalized.localized() + "!"
        fishSizeLabel.text = ""
        fishRarityLabel.text = "Rarity: ".localized() + junk.rarity.rawValue.capitalized.localized()
    }

    @IBAction func nextButton(_ sender: Any) {
        SoundManager.shared.playSound(sound: .bubble4)
    }
}
