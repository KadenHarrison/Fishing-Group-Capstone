//
//  SellTotalTableViewCell.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/25/25.
//

import UIKit

/// Cell that displays the total amount made by the user from a list of fish.
class SellTotalTableViewCell: UITableViewCell {

    @IBOutlet var totalLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DynamicTypeFontHelper().applyDynamicFont(fontName: "GillSans-UltraBold", size: 22, textStyle: .title2, to: totalTextLabel)
        DynamicTypeFontHelper().applyDynamicFont(fontName: "GillSans", size: 28, textStyle: .title1, to: totalLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTotal(_ string: String) {
        self.totalLabel.text = string
    }

}
