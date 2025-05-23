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
    
    /// Table views for each item in the shop
    @IBOutlet weak var baitStackView: UIStackView!
    @IBOutlet weak var hookStackView: UIStackView!
    @IBOutlet weak var lineStackView: UIStackView!
    @IBOutlet weak var boatStackView: UIStackView!
    @IBOutlet weak var licenseStackView: UIStackView!
    @IBOutlet weak var checkoutStackView: UIStackView!
    
    /// Images for each item in the shop
    @IBOutlet weak var baitImage: UIImageView!
    @IBOutlet weak var hookImage: UIImageView!
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var boatImage: UIImageView!
    @IBOutlet weak var licenseImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAllUpgradeLabels()
        
        baitInventoryLabel.text = "\("Inventory:".localized()) \(tacklebox.baitCount)"

        if let nextFishingLicense = FishingLicense(rawValue: tacklebox.fishingLicense.rawValue + 1) {
            nextFishingLicenseLabel.text = "\("Next:".localized()) \(nextFishingLicense.displayName.localized())"
        } else {
            nextFishingLicenseLabel.text = "Fully Upgraded!".localized()
        }
        
        remainingCashAmountLabel.text = "$\(tacklebox.cash)"
        
        /// Applies the capsule design to the stack views
        DesignHelper.applyCapsuleDesign(baitStackView)
        DesignHelper.applyCapsuleDesign(hookStackView)
        DesignHelper.applyCapsuleDesign(lineStackView)
        DesignHelper.applyCapsuleDesign(boatStackView)
        DesignHelper.applyCapsuleDesign(licenseStackView)
        DesignHelper.applyCapsuleDesign(checkoutStackView)
        
        /// Applies the image design to the stack views
        DesignHelper.applyImageDesign(baitImage)
        DesignHelper.applyImageDesign(hookImage)
        DesignHelper.applyImageDesign(lineImage)
        DesignHelper.applyImageDesign(boatImage)
        DesignHelper.applyImageDesign(licenseImage)
    }
    
    func updateUpgradeLabel<T: Upgradable & Displayable>(current: T, label: UILabel) {
        if let next = current.next {
            label.text = "\("Next:".localized()) \(next.displayName.localized())"
        } else {
            label.text = "Fully Upgraded!".localized()
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
        remainingCashAmountLabel.text = "\("$".localized())\(tacklebox.cash)"
    }
    
    /// Decreases the bait count of the user once called
    @IBAction func decreaseBaitCount(_ sender: Any) {
        shopController.decreaseBaitCount()
        updateUI()
        SoundManager.shared.playSound(sound: .bubble2)
    }
    
    /// Removes cash from the player and exchanges it for bait that the user can use
    @IBAction func increaseBaitCount(_ sender: Any) {
        shopController.increaseBaitCount()
        updateUI()
        SoundManager.shared.playSound(sound: .bubble4)
    }
    
    /// Determines whether or not the player has selected to upgrade their hook.
    @IBAction func upgradeHook(_ sender: UIButton) {
        shopController.upgradeHook()
        SoundManager.shared.playSound(sound: .bubble3)
        if shopController.hookUpgraded {
            nextHookLabel.text = "Purchased!".localized()
        } else if let next = shopController.nextHook {
            nextHookLabel.text = "\("Next:".localized()) \(next.displayName.localized())"
        }
        
        let imageName = shopController.hookUpgraded ? "arrowshape.up.fill" : "arrowshape.up"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        updateUI()
    }
    
    /// Determines whether or not the player has selected to upgrade their line.
    @IBAction func upgradeLine(_ sender: UIButton) {
        shopController.upgradeLine()
        SoundManager.shared.playSound(sound: .bubble4)
        if shopController.lineUpgraded {
            nextLineLabel.text = "Purchased!".localized()
        } else if let next = shopController.nextLine {
            nextLineLabel.text = "\("Next:".localized()) \(next.displayName.localized())"
        }
        
        let imageName = shopController.lineUpgraded ? "arrowshape.up.fill" : "arrowshape.up"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        updateUI()
    }
    
    /// Determines whether or not the player has selected to upgrade their boat.
    @IBAction func upgradeBoat(_ sender: UIButton) {
        shopController.upgradeBoat()
        SoundManager.shared.playSound(sound: .bubble1)
        if shopController.boatUpgraded {
            nextBoatLabel.text = "Purchased!".localized()
        } else if let next = shopController.nextBoat {
            nextBoatLabel.text = "\("Next:".localized()) \(next.displayName.localized())"
        }
        
        let imageName = shopController.boatUpgraded ? "arrowshape.up.fill" : "arrowshape.up"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        updateUI()
    }
    
    /// Determines whether or not the player has selected to upgrade their license.
    @IBAction func upgradeLicense(_ sender: UIButton) {
        shopController.upgradeLicense()
        SoundManager.shared.playSound(sound: .bubble3)
        if shopController.licenseUpgraded {
            nextFishingLicenseLabel.text = "Purchased!".localized()
        } else if let next = shopController.nextFishingLicense {
            nextFishingLicenseLabel.text = "\("Next:".localized()) \(next.displayName)"
        }
        
        let imageName = shopController.licenseUpgraded ? "arrowshape.up.fill" : "arrowshape.up"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        updateUI()
    }
    
    /// Asks you to confirm that you are finished shopping, and then call the completeCheckout function
    @IBAction func checkout(_ sender: Any) {
        SoundManager.shared.playSound(sound: .bubble4)
        let alert = UIAlertController(title: "Checkout".localized(), message: "Are you sure you want to checkout?".localized(), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes".localized(), style: .default) { _ in
            self.shopController.completeCheckout()
            self.performSegue(withIdentifier: "unwindToLocationSelection", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "No".localized(), style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    

    func updateUI() {
        baitCountLabel.text = "+\(shopController.baitCount)"

        remainingCashAmountLabel.text = "$\(shopController.remainingCash)"
    }
}
