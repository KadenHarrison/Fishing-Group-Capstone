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
    
    var amountSpent: Int {
        var total = 0
        total += baitCount * 5
        total += hookUpgraded ? 100 : 0
        total += lineUpgraded ? 500 : 0
        total += boatUpgraded ? 2000 : 0
        total += licenseUpgraded ? 5000 : 0
        return total
    }
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
    
    func decreaseBaitCount() {
        baitCount -= 1
        baitCount = max(baitCount, 0)
    }
    func increaseBaitCount() {
        let canAffordBait = tacklebox.cash - amountSpent > 5
        
        if canAffordBait {
            baitCount += 1
        }
    }
    func upgradeHook() {
        let canAffordHook = tacklebox.cash - amountSpent > 100
        
        if !hookUpgraded && canAffordHook {
            hookUpgraded = true
        } else if hookUpgraded {
            hookUpgraded = false
        }
    }
    func upgradeLine() {
        let canAffordLine = tacklebox.cash - amountSpent > 500
        
        if !lineUpgraded && canAffordLine {
            lineUpgraded = true
        } else if lineUpgraded {
            lineUpgraded = false
        }
    }
    func upgradeBoat() {
        let canAffordboat = tacklebox.cash - amountSpent > 2000

        if !boatUpgraded && canAffordboat {
            boatUpgraded = true
        } else if boatUpgraded {
            boatUpgraded = false
        }
    }
    func upgradeLicense() {
        let canAffordlicense = tacklebox.cash - amountSpent > 5000

        if !licenseUpgraded && canAffordlicense {
            licenseUpgraded = true
        } else if licenseUpgraded {
            licenseUpgraded = false
        }
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
    }
}
