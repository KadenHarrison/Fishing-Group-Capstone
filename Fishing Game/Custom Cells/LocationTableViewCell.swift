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
        setupRoundedCorners()
        // Initialization code
        
        DynamicTypeFontHelper().applyDynamicFont(fontName: "GillSans-UltraBold", size: 24, textStyle: .title2, to: locationLabel)
        DynamicTypeFontHelper().applyDynamicFont(fontName: "GillSans-SemiBold", size: 18, textStyle: .title3, to: availabilityLabel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupRoundedCorners() {
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func configureCell(for location: Location) {
        self.location = location
        self.locationThumbnailImageView.image = UIImage(named: location.thumbnailName)
        self.locationLabel.text = location.name
        
        // Checks if the user has a valuable enough license and boat for the location
        let unlockedLicense = location.requiredLicense.rawValue <= TackleboxService.shared.tacklebox.fishingLicense.rawValue
        let unlockedBoat = location.requiredBoat.rawValue <= TackleboxService.shared.tacklebox.boat.rawValue
        
        let totalFish = location.availableFish.count
        let caughtFish = location.locationCaughtFish?.caughtFish.count ?? 0
        
        if unlockedLicense && unlockedBoat {
            lockIconImageView.isHidden = true
            print("kbdb: \(location.locationCaughtFish?.caughtFish.count)")
            availabilityLabel.text = "\("Fish caught: ".localized()) \(caughtFish) / \(totalFish)"
        } else {
            lockIconImageView.isHidden = false
            availabilityLabel.text = ("\("Requires license".localized()) \(location.requiredLicense.displayName.localized()) \("and".localized()) \(location.requiredBoat.displayName.localized())")
        }
    }
}
