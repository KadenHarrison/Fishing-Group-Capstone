//
//  LocationTableViewCell.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/2/25.
//

import UIKit

/// Cell that displays information about a location, including location image, name, and if the location is unlocked.
class LocationTableViewCell: UITableViewCell {

    private var location: Location?
    
    @IBOutlet weak var locationThumbnailImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    
    @IBOutlet weak var lockIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(for location: Location) {
        self.location = location
        self.locationThumbnailImageView.image = UIImage(named: location.thumbnailName)
        self.locationLabel.text = location.name
        
        // Checks if the user has a valuable enough license and boat for the location
        let unlockedLicense = location.requiredLicense.rawValue <= Tacklebox.shared.fishingLicense.rawValue
        let unlockedBoat = location.requiredBoat.rawValue <= Tacklebox.shared.boat.rawValue
        if unlockedLicense && unlockedBoat {
            lockIconImageView.isHidden = true
            availabilityLabel.text = "Fish caught: \(location.caughtFish.count) / \(location.availableFish.count)"
        } else {
            lockIconImageView.isHidden = false
            availabilityLabel.text = "Requires license \(location.requiredLicense.displayName) and \(location.requiredBoat.displayName)"
        }
    }
}
