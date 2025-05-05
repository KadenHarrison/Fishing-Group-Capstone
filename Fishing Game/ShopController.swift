//
//  ShopController.swift
//  Fishing Game
//
//  Created by Kevin Bjornberg on 4/28/25.
//

import Foundation

class ShopController {
    
    let tacklebox = TackleboxService.shared.tacklebox
    
    var baitCount = 0
    var hookUpgraded = false
    var lineUpgraded = false
    var boatUpgraded = false
    var licenseUpgraded = false
    
    /// Pricing for items in the shop
    var baitCost: Int = 5
    var hookCost: Int = 100
    var lineCost: Int = 500
    var boatCost: Int = 2000
    var licenseCost: Int = 5000
    
    /// Calculates how much is being spent in the shop
    var amountSpent: Int {
        var total = 0
        total += baitCount * 5
        total += hookUpgraded ? 100 : 0
        total += lineUpgraded ? 500 : 0
        total += boatUpgraded ? 2000 : 0
        total += licenseUpgraded ? 5000 : 0
        return total
    }
    
    /// Basic calculations in order to calculate how much is being spent and how much the player has remaining
    var remainingCash: Int {
        tacklebox.cash - amountSpent
    }
    var nextHook: Hook? {
        Hook(rawValue: tacklebox.hook.rawValue + 1)
    }
    var nextLine: Line? {
        Line(rawValue: tacklebox.line.rawValue + 1)
    }
    var nextBoat: Boat? {
        Boat(rawValue: tacklebox.boat.rawValue + 1)
    }
    var nextFishingLicense: FishingLicense? {
        FishingLicense(rawValue: tacklebox.fishingLicense.rawValue + 1)
    }
    
    /// Calculates the amount of bait that the player has after purchasing and using bait
    func decreaseBaitCount() {
        baitCount -= 1
        baitCount = max(baitCount, 0)
    }
    func increaseBaitCount() {
        let canAffordBait = tacklebox.cash - amountSpent > baitCost
        
        if canAffordBait {
            baitCount += 1
        }
    }
    
    // MARK: Logic for handling whether the player is purchasing the upgrade or not
    func upgradeHook() {
        let canAffordHook = tacklebox.cash - amountSpent > hookCost
        
        if !hookUpgraded && canAffordHook {
            hookUpgraded = true
        } else if hookUpgraded {
            hookUpgraded = false
        }
    }
    func upgradeLine() {
        let canAffordLine = tacklebox.cash - amountSpent > lineCost
        
        if !lineUpgraded && canAffordLine {
            lineUpgraded = true
        } else if lineUpgraded {
            lineUpgraded = false
        }
    }
    func upgradeBoat() {
        let canAffordboat = tacklebox.cash - amountSpent > boatCost

        if !boatUpgraded && canAffordboat {
            boatUpgraded = true
        } else if boatUpgraded {
            boatUpgraded = false
        }
    }
    func upgradeLicense() {
        let canAffordlicense = tacklebox.cash - amountSpent > licenseCost

        if !licenseUpgraded && canAffordlicense {
            licenseUpgraded = true
        } else if licenseUpgraded {
            licenseUpgraded = false
        }
    }
    
    /// Takes the players ammount spent and subtracts it from the players cash. And then checks what the player actually purchased
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
    }
}
