//
//  CaughtFishTableViewCell.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/24/25.
//

import UIKit

/// Cell that displays information about a fish including fish name, image, and price.
class CaughtFishTableViewCell: UITableViewCell {

    @IBOutlet var fishImageView: UIImageView!
    @IBOutlet var fishNameLabel: UILabel!
    @IBOutlet var fishPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DynamicTypeFontHelper().applyDynamicFont(fontName: "GillSans-UltraBold", size: 22, textStyle: .title2, to: fishNameLabel)
        DynamicTypeFontHelper().applyDynamicFont(fontName: "GillSans", size: 18, textStyle: .title3, to: fishPriceLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFish(fish: Fish) {
        fishImageView.image = fish.image
        fishNameLabel.text = fish.type.rawValue.uppercased()
        let fishPrice = fish.price.formatted(.currency(code: "USD"))
        fishPriceLabel.text = fishPrice
    }

}
