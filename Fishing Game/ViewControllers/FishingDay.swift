//
//  FishingDay.swift
//  Fishing Game
//
//  Created by Kaden Harrison on 4/29/25.
//

import Foundation

protocol FishingDayDelegate: AnyObject {
    func handleEndOfDay(isEarly: Bool)
    func dayTimeUpdated(time: String)
}

class FishingDay {
    weak var fishingReel: FishingReel?
    weak var viewController: FishingScreenViewController?
    var delegate: FishingDayDelegate?
    let tacklebox = Tacklebox.shared
    // Time the user has to wait until a fish appears
    var fishAppearsTimer: FishAppearsTimer?
    // Time the user has to fish until the session ends
    var dayCycleTimer: DayCycleTimer?
    // Time the user has to reel the fish in
    var catchTimeTimer: CatchTimeTimer?
    
    var caughtFish: [Fish] = []
    var location: Location?
    
    
    
    init(fishAppearsTimer: FishAppearsTimer? = nil, dayCycleTimer: DayCycleTimer? = nil) {
        self.fishAppearsTimer = fishAppearsTimer
        self.dayCycleTimer = dayCycleTimer
        setup()
    }
    func setup() {
        // If there is no day timer, start the day cycle timer
        if dayCycleTimer == nil {
            dayCycleTimer = DayCycleTimer(tickHandler: { [weak self] timeSinceStart in
                guard let self else {return}
                print("TICK: \(timeSinceStart)")
                // Calculates the time of day: 0 corresponds to 9:00 AM, with every 15 seconds representing 1 hour; the day ends at midnight
                let timeOfDay = 9.0 + (timeSinceStart.rounded(toPlaces: 1) / 15)
                
                
                let amOrPm = timeOfDay >= 12.0 ? "PM" : "AM"
                
                // Converts the time to a 12-hour format
                let formattedTime = "\(Int(timeOfDay) % 12 == 0 ? 12 : Int(timeOfDay) % 12):00 \(amOrPm)"
                
                self.delegate?.dayTimeUpdated(time: formattedTime)
                
                // Ends the day when the timer completes
            }, completionHandler: {
                self.endDay(early: false)
            })
            
            dayCycleTimer?.start()
        }
    }
    /// Called when you run out of bait or time, ending the day
    func endDay(early: Bool) {
            //stop all timers
            self.fishAppearsTimer?.stop()
            self.catchTimeTimer?.stop()
            self.dayCycleTimer?.stop()
            
            // Saves all the fish you've caught
            if let location {
                // Get or create the player's record for this location
                if location.locationCaughtFish == nil {
                    location.locationCaughtFish = LocationCaughtFish(location: location, caughtFish: [])
                }
                        
                var record = location.locationCaughtFish!

                // Filter new, unique fish types
                let newFishTypes = caughtFish
                    .map { $0.type }
                    .filter { !record.caughtFish.contains($0) }

                // Update the record
                record.caughtFish.formUnion(newFishTypes)
                // Location.save()
                // Need to refactor saving and loading still
                delegate?.handleEndOfDay(isEarly: early)
            }
        }
       
    // If bait reaches 0, the day will end
    func checkBait() {
        if self.tacklebox.baitCount <= 0 {
            self.endDay(early: true)
        }
    }
}

