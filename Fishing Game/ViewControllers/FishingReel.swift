//
//  FishingReel.swift
//  Fishing Game
//
//  Created by Kaden Harrison on 4/29/25.
//

import Foundation
import UIKit

class FishingReel {
    weak var fishingDay: FishingDay?
    weak var viewController: FishingScreenViewController?
    
    var requiredSpins = 0
    var reelProgress = 0.0
    
    // Time the user has to grab the hook to start catching the fish
    var hookTimer: HookTimer?
    
    // You have a certain amount of time that is calculated based on the fish before it gets away
    func startHookTimer() {
        hookTimer = HookTimer() {
            self.fishGotAway()
        }
        
        hookTimer?.start()
    }
    /// haha your a bad fisherman. The fish you "almost" got is gone forever and totally reset for another random fish
    func fishGotAway() {
        // I think this resets the fish😉
        resetFish()
        viewController?.radarDisplayImageView.image = UIImage(named: "radar")
        
        hookTimer?.stop()
        fishingDay?.catchTimeTimer?.stop()
        
        // Gives you 5 seconds to contemplate your fisherman skills
        fishingDay?.catchTimeTimer = CatchTimeTimer(countdownTime: 5) { timeSinceStart in
            let timeRemaining = TimeInterval(5) - timeSinceStart
            
            self.viewController?.timeRemainingLabel.text = ("\("Missed...".localized()) \(timeRemaining.rounded(toPlaces: 1))")
        } completionHandler: {
            // resets everything after losing
            self.viewController?.timeRemainingLabel.text = ""
            self.fishingDay?.checkBait()
            self.viewController?.toggleBoatHidden(false)
            self.fishingDay?.fishAppearsTimer?.start()
        }
        
        fishingDay?.catchTimeTimer?.start()
    }
    func resetFish() {
        viewController?.reelingInFish = false
        viewController?.fishHasAppeared = false
        viewController?.fish = nil
        viewController?.totalRotationAngle = 0
        viewController?.previousTouchPoint = CGPoint()
        reelProgress = 0
        requiredSpins = 0
    }
    func generateRandomItem() {
        let rarity = FishFactory.randomRarity()
        if rarity == .junk {
            viewController?.junk = FishFactory.generateRandomJunk(from: fishingDay?.location?.availableJunk ?? JunkType.allCases)
            viewController?.fish = nil
        } else {
            let types = fishingDay?.location?.availableFish ?? FishType.allCases
            viewController?.fish = FishFactory.generateRandomFish(from: types, rarity: rarity)
            viewController?.junk = nil
            
        }
        let junk = viewController?.junk
        let fish = viewController?.fish
        
        if let fish {
            requiredSpins = Int(fish.size)
            NSLog("Generated \(fish))")
        } else if let junk { // junk
            requiredSpins = 10
            NSLog("Generated JUNK\(junk.type))")
        }
    }
    
    /// Starts the timer for how long you have to reel before the fish escapes
    func startCatchCountdown() {
        //gets catch time
        let catchTime = calculateCatchTime()
        
        // starts catch time
        fishingDay?.catchTimeTimer = CatchTimeTimer(countdownTime: catchTime) { timeSinceStart in
            //counts down timer
            let timeRemaining = (catchTime) - timeSinceStart
            // updates timer label
            self.viewController?.timeRemainingLabel.text = "⏱️ \(Int(timeRemaining.rounded(toPlaces: 1)))s"
        } completionHandler: {
            // if time runs out fish gets away
            self.fishGotAway()
        }
        fishingDay?.catchTimeTimer?.start()
    }
    
    /// Called when the reel is complete
    func catchFish() {
        if let viewController = viewController {
            viewController.reelingInFish = false
            viewController.timeRemainingLabel.text = ""
            fishingDay?.catchTimeTimer?.stop()
            viewController.moveReelToDefaultNoFishPosition()
            
            if let fish = viewController.fish {
                if let location = viewController.fishingDay.location {
                    JournalService.shared.recordCatch(fish, at: location)
                    print(JournalService.shared.journal.entries.count)
                }
            }
            
            viewController.transitionToCatchScreen()
        }
        
        
    }
    // Depending on the fishing line, you get extra time for reeling
    func calculateCatchTime() -> TimeInterval {
        let baseCatchTime = TimeInterval(20)
        
        var bonusCatchTime: TimeInterval {
            switch fishingDay?.tackleboxService.tacklebox.line {
            case .twine:
                return 0
            case .monofilament:
                return 5
            case .fluorocarbon:
                return 10
            case .none:
                return 0
            }
        }
        
        return baseCatchTime + bonusCatchTime
    }
    // Uses one bait when a fish bites
    func useBait() {
        print("Used bait")
        SoundManager.shared.playSound(sound: .bubble2)
        guard let bait = fishingDay?.tackleboxService.tacklebox.baitCount, bait > 0 else { return }
        fishingDay?.tackleboxService.tacklebox.baitCount -= 1
        TackleboxService.shared.save()
        viewController?.baitRemainingLabel.text = "\("Bait Remaining:".localized()) \(String(describing: fishingDay?.tackleboxService.tacklebox.baitCount ?? 0))"
        
    }
}
