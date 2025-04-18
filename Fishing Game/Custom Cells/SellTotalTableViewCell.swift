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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTotal(_ string: String) {
        self.totalLabel.text = string
    }

}
