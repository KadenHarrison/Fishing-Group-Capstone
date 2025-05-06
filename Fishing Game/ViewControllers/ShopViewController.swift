//
//  ShopViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/1/25.
//

import UIKit

class ShopViewController: UIViewController {
    
    let tacklebox = TackleboxService.shared.tacklebox
    let shopController = ShopController()

    @IBOutlet weak var baitCountLabel: UILabel!
    @IBOutlet weak var baitInventoryLabel: UILabel!
    @IBOutlet weak var remainingCashAmountLabel: UILabel!
    @IBOutlet weak var nextHookLabel: UILabel!
    @IBOutlet weak var nextLineLabel: UILabel!
    @IBOutlet weak var nextBoatLabel: UILabel!
    @IBOutlet weak var nextFishingLicenseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAllUpgradeLabels()
        
        baitInventoryLabel.text = "Inventory: \(tacklebox.baitCount)"

        if let nextFishingLicense = FishingLicense(rawValue: tacklebox.fishingLicense.rawValue + 1) {
            nextFishingLicenseLabel.text = "Next: \(nextFishingLicense.displayName)"
        } else {
            nextFishingLicenseLabel.text = "Fully Upgraded!"
        }
        
        remainingCashAmountLabel.text = "$\(tacklebox.cash)"
    }
    
    func updateUpgradeLabel<T: Upgradable & Displayable>(current: T, label: UILabel) {
        if let next = current.next {
            label.text = "Next: \(next.displayName)"
        } else {
            label.text = "Fully Upgraded!"
        }
    }
    
    func updateAllUpgradeLabels() {
        updateUpgradeLabel(current: tacklebox.hook, label: nextHookLabel)
        updateUpgradeLabel(current: tacklebox.line, label: nextLineLabel)
        updateUpgradeLabel(current: tacklebox.boat, label: nextBoatLabel)
    }

    @IBAction func debugFreeMoney(_ sender: Any) {
        // For testing only, remove when no longer needed
        tacklebox.cash += 1000
        remainingCashAmountLabel.text = "$\(tacklebox.cash)"
    }
    
    /// Decreases the bait count of the user once called
    @IBAction func decreaseBaitCount(_ sender: Any) {
        shopController.decreaseBaitCount()
        updateUI()
        SoundManager.shared.playSound(named: "bubble2")
    }
    
    /// Removes cash from the player and exchanges it for bait that the user can use
    @IBAction func increaseBaitCount(_ sender: Any) {
        shopController.increaseBaitCount()
        updateUI()
        SoundManager.shared.playSound(named: "bubble4")
    }
    
    /// Determines whether or not the player has selected to upgrade their hook.
    @IBAction func upgradeHook(_ sender: UIButton) {
        shopController.upgradeHook()
        SoundManager.shared.playSound(named: "bubble3")
        if shopController.hookUpgraded {
            nextHookLabel.text = "Purchased!"
        } else if let next = shopController.nextHook {
            nextHookLabel.text = "Next: \(next.displayName)"
        }
        
        let imageName = shopController.hookUpgraded ? "arrowshape.up.fill" : "arrowshape.up"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        updateUI()
    }
    
    /// Determines whether or not the player has selected to upgrade their line.
    @IBAction func upgradeLine(_ sender: UIButton) {
        shopController.upgradeLine()
        SoundManager.shared.playSound(named: "bubble4")
        if shopController.lineUpgraded {
            nextLineLabel.text = "Purchased!"
        } else if let next = shopController.nextLine {
            nextLineLabel.text = "Next: \(next.displayName)"
        }
        
        let imageName = shopController.lineUpgraded ? "arrowshape.up.fill" : "arrowshape.up"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        updateUI()
    }
    
    /// Determines whether or not the player has selected to upgrade their boat.
    @IBAction func upgradeBoat(_ sender: UIButton) {
        shopController.upgradeBoat()
        SoundManager.shared.playSound(named: "bubble1")
        if shopController.boatUpgraded {
            nextBoatLabel.text = "Purchased!"
        } else if let next = shopController.nextBoat {
            nextBoatLabel.text = "Next: \(next.displayName)"
        }
        
        let imageName = shopController.boatUpgraded ? "arrowshape.up.fill" : "arrowshape.up"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        updateUI()
    }
    
    /// Determines whether or not the player has selected to upgrade their license.
    @IBAction func upgradeLicense(_ sender: UIButton) {
        shopController.upgradeLicense()
        SoundManager.shared.playSound(named: "bubble3")
        if shopController.licenseUpgraded {
            nextFishingLicenseLabel.text = "Purchased!"
        } else if let next = shopController.nextFishingLicense {
            nextFishingLicenseLabel.text = "Next: \(next.displayName)"
        }
        
        let imageName = shopController.licenseUpgraded ? "arrowshape.up.fill" : "arrowshape.up"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        updateUI()
    }
    
    /// Asks you to confirm that you are finished shopping, and then call the completeCheckout function
    @IBAction func checkout(_ sender: Any) {
        SoundManager.shared.playSound(named: "bubble4")
        let alert = UIAlertController(title: "Checkout", message: "Are you sure you want to checkout?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.shopController.completeCheckout()
            self.performSegue(withIdentifier: "unwindToLocationSelection", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    

    func updateUI() {
        baitCountLabel.text = "+\(shopController.baitCount)"

        remainingCashAmountLabel.text = "$\(shopController.remainingCash)"
    }
}
