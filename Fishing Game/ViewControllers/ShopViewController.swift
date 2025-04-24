//
//  ShopViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/1/25.
//

import UIKit

class ShopViewController: UIViewController {
    
    let tacklebox = TackleboxService.shared.tacklebox
    
    var baitCount = 0
    var hookUpgraded = false
    var lineUpgraded = false
    var boatUpgraded = false
    var licenseUpgraded = false
    
    var amountSpent: Int {
        var total = 0
        total += baitCount * 5
        total += hookUpgraded ? 100 : 0
        total += lineUpgraded ? 500 : 0
        total += boatUpgraded ? 2000 : 0
        total += licenseUpgraded ? 5000 : 0
        return total
    }
    
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
        
//        if let nextHook = Hook(rawValue: tacklebox.hook.rawValue + 1) {
//            nextHookLabel.text = "Next: \(nextHook.displayName)"
//        } else {
//            nextHookLabel.text = "Fully Upgraded!"
//        }
//        
//        if let nextLine = Line(rawValue: tacklebox.line.rawValue + 1) {
//            nextLineLabel.text = "Next: \(nextLine.displayName)"
//        } else {
//            nextLineLabel.text = "Fully Upgraded!"
//        }
//
//        if let nextBoat = Boat(rawValue: tacklebox.boat.rawValue + 1) {
//            nextBoatLabel.text = "Next: \(nextBoat.displayName)"
//        } else {
//            nextBoatLabel.text = "Fully Upgraded!"
//        }

        if let nextFishingLicense = FishingLicense(rawValue: tacklebox.fishingLicense.rawValue + 1) {
            nextFishingLicenseLabel.text = "Next: \(nextFishingLicense.displayName)"
        } else {
            nextFishingLicenseLabel.text = "Fully Upgraded!"
        }
        
        remainingCashAmountLabel.text = "$\(tacklebox.cash)"
    }
    
    func updateUpgradeLabel<T: RawRepresentable>(
        current: T,
        label: UILabel,
        displayName: (T) -> String
    ) where T.RawValue == Int {
        if let next = T(rawValue: current.rawValue + 1) {
            label.text = "Next: \(displayName(next))"
        } else {
            label.text = "Fully Upgraded!"
        }
    }
    
    func updateAllUpgradeLabels() {
        updateUpgradeLabel(current: tacklebox.hook, label: nextHookLabel) { $0.displayName }
        updateUpgradeLabel(current: tacklebox.line, label: nextLineLabel) { $0.displayName }
        updateUpgradeLabel(current: tacklebox.boat, label: nextBoatLabel) { $0.displayName }
    }

    @IBAction func debugFreeMoney(_ sender: Any) {
        // For testing only, remove when no longer needed
        tacklebox.cash += 1000
        remainingCashAmountLabel.text = "$\(tacklebox.cash)"
    }
    
    /// Decreases the bait count of the user once called
    @IBAction func decreaseBaitCount(_ sender: Any) {
        baitCount -= 1
        
        if baitCount < 0 {
            baitCount = 0
        }
        
        baitCountLabel.text = "+\(baitCount)"
        
        let cash = tacklebox.cash

        remainingCashAmountLabel.text = "$\(cash - amountSpent)"
    }
    
    /// Removes cash from the player and exchanges it for bait that the user can use
    @IBAction func increaseBaitCount(_ sender: Any) {
        let cash = tacklebox.cash
        
        let canAffordBait = cash - amountSpent > 5
        
        if canAffordBait {
            baitCount += 1
        }
        
        baitCountLabel.text = "+\(baitCount)"
                
        remainingCashAmountLabel.text = "$\(cash - amountSpent)"
    }
    
    /// Determines whether or not the player has selected to upgrade their hook.
    @IBAction func upgradeHook(_ sender: UIButton) {
        let cash = tacklebox.cash
        
        let canAffordHook = cash - amountSpent > 100
        
        if !hookUpgraded && canAffordHook {
            hookUpgraded = true
            nextHookLabel.text = "Purchased!"
        } else if hookUpgraded {
            if let nextHook = Hook(rawValue: tacklebox.hook.rawValue + 1) {
                nextHookLabel.text = "Next: \(nextHook.displayName)"
            }
            
            hookUpgraded = false
        }
        
        sender.setImage(UIImage(systemName: hookUpgraded ? "arrowshape.up.fill" : "arrowshape.up"), for: .normal)
        
        remainingCashAmountLabel.text = "$\(cash - amountSpent)"
    }
    
    /// Determines whether or not the player has selected to upgrade their line.
    @IBAction func upgradeLine(_ sender: UIButton) {
        let cash = tacklebox.cash
        
        let canAffordLine = cash - amountSpent > 500
        
        if !lineUpgraded && canAffordLine {
            lineUpgraded = true
            nextLineLabel.text = "Purchased!"
        } else if lineUpgraded {
            if let nextLine = Line(rawValue: tacklebox.line.rawValue + 1) {
                nextLineLabel.text = "Next: \(nextLine.displayName)"
            }
            
            lineUpgraded = false
        }
        
        sender.setImage(UIImage(systemName: lineUpgraded ? "arrowshape.up.fill" : "arrowshape.up"), for: .normal)
        
        remainingCashAmountLabel.text = "$\(cash - amountSpent)"
    }
    
    /// Determines whether or not the player has selected to upgrade their boat.
    @IBAction func upgradeBoat(_ sender: UIButton) {
        let cash = tacklebox.cash
        
        let canAffordboat = cash - amountSpent > 2000
        
        if !boatUpgraded && canAffordboat {
            boatUpgraded = true
            nextBoatLabel.text = "Purchased!"
        } else if boatUpgraded {
            if let nextBoat = Boat(rawValue: tacklebox.boat.rawValue + 1) {
                nextBoatLabel.text = "Next: \(nextBoat.displayName)"
            }
            
            boatUpgraded = false
        }
        
        sender.setImage(UIImage(systemName: boatUpgraded ? "arrowshape.up.fill" : "arrowshape.up"), for: .normal)
        
        remainingCashAmountLabel.text = "$\(cash - amountSpent)"
    }
    
    /// Determines whether or not the player has selected to upgrade their license.
    @IBAction func upgradeLicense(_ sender: UIButton) {
        let cash = tacklebox.cash
        
        let canAffordlicense = cash - amountSpent > 5000
        
        if !licenseUpgraded && canAffordlicense {
            licenseUpgraded = true
            nextFishingLicenseLabel.text = "Purchased!"
        } else if licenseUpgraded {
            if let nextFishingLicense = FishingLicense(rawValue: tacklebox.fishingLicense.rawValue + 1) {
                nextFishingLicenseLabel.text = "Next: \(nextFishingLicense.displayName)"
            }
            
            licenseUpgraded = false
        }
        
        sender.setImage(UIImage(systemName: licenseUpgraded ? "arrowshape.up.fill" : "arrowshape.up"), for: .normal)
        
        remainingCashAmountLabel.text = "$\(cash - amountSpent)"
    }
    
    /// Asks you to confirm that you are finished shopping, and then call the completeCheckout function
    @IBAction func checkout(_ sender: Any) {
        let alert = UIAlertController(title: "Checkout", message: "Are you sure you want to checkout?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.completeCheckout()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    /// Grabs the total ammount of cash that the user has spent on upgrades and bait, and then subtracts it from the cash that the player has
    func completeCheckout() {
        let tacklebox = tacklebox
        
        tacklebox.cash -= amountSpent
        
        tacklebox.baitCount += baitCount
        
        if hookUpgraded {
            tacklebox.hook.upgrade()
        }
        
        if lineUpgraded {
            tacklebox.line.upgrade()
        }
        
        if boatUpgraded {
            tacklebox.boat.upgrade()
        }
        
        if licenseUpgraded {
            tacklebox.fishingLicense.upgrade()
        }
        
        TackleboxService.shared.save()
        
        performSegue(withIdentifier: "unwindToLocationSelection", sender: nil)
    }
}
