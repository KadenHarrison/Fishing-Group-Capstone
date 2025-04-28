//
//  FishingScreenViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/2/25.

import UIKit

class FishingScreenViewController: UIViewController {
    var location: Location?
    
    private let tacklebox = TackleboxService.shared.tacklebox
    
//MARK: Timers
    // Time the user has to wait until a fish appears
    private var fishAppearsTimer: FishAppearsTimer?
    // Tine the user has to grab the hook to start catching the fish
    private var hookTimer: HookTimer?
    // Time the user has to reel the fish in
    private var catchTimeTimer: CatchTimeTimer?
    // Time the user has to fish until the session ends
    private var dayCycleTimer: DayCycleTimer?
    
    // Tracks the progress and current state of the player
    private var fishHasAppeared = false
    private var reelingInFish = false
    private var fish: Fish? = nil
    private var caughtFish: [Fish] = []
    private var requiredSpins = 0
    private var reelProgress = 0.0
    
    // Tracks how many times the rod has been rotated by the user
    private var previousTouchPoint = CGPoint()
    private var totalRotationAngle: CGFloat = 0
    private var totalRotations: Int {
        Int(Double(totalRotationAngle) / (2.0 * Double.pi))
    }
    
    // All the different images used in the game
    @IBOutlet weak var boatImageView: UIImageView!
    @IBOutlet weak var radarDisplayImageView: UIImageView!
    @IBOutlet weak var fishingProgressImageView: UIImageView!
    @IBOutlet weak var spinningReelImageView: UIImageView!
    
    // Tracks where the user has tapped or swiped on the screen
    @IBOutlet var gestureRecognizer: UIPanGestureRecognizer!
    // Labels to display the time, distance, and remaining bait
    @IBOutlet weak var distanceToFishLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var baitRemainingLabel: UILabel!
    
    // Displays your progress in the game
    @IBOutlet var clockLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Shows the screen while waiting for a fish
        toggleBoatHidden(false)
        
        // Updates the displayed bait count
        self.baitRemainingLabel.text = "Bait Remaining: \(tacklebox.baitCount)"
        
        // Sets the background image based on the fishing location
        self.boatImageView.image = UIImage(named: location?.backgroundName ?? "boat")
        
        // Loads the radar image
        self.radarDisplayImageView.image = UIImage(named: "radar")
        
        // Determines the maximum time for a fish to bite based on the hook type
        var maxTimeUntilFishAppears: TimeInterval {
            switch tacklebox.hook {
            case .carvedWood:
                return 60
            case .plastic:
                return 50
            case .steel:
                return 40
            }
        }
        
        // Starts the timer for the next fish appearance
        self.fishAppearsTimer = FishAppearsTimer(maxTime: maxTimeUntilFishAppears) {
            self.generateRandomFish()
            self.useBait()
            self.showFishAppeared()
            self.startHookTimer()
        }
             
        // If there is no day timer, start the day cycle timer
        if dayCycleTimer == nil {
            dayCycleTimer = DayCycleTimer(tickHandler: { timeSinceStart in
                
                print("TICK: \(timeSinceStart)")
                // Calculates the time of day: 0 corresponds to 9:00 AM, with every 15 seconds representing 1 hour; the day ends at midnight
                let timeOfDay = 9.0 + (timeSinceStart.rounded(toPlaces: 1) / 15)
                
                
                let amOrPm = timeOfDay >= 12.0 ? "PM" : "AM"
                
                // Converts the time to a 12-hour format
                let formattedTime = "\(Int(timeOfDay) % 12 == 0 ? 12 : Int(timeOfDay) % 12):00 \(amOrPm)"
                
                self.clockLabel.text = formattedTime
                // Ends the day when the timer completes
            }, completionHandler: {
                self.endDay(early: false)
            })
            
            dayCycleTimer?.start()
        }
        
        moveReelToDefaultNoFishPosition()
    }
    /// When the view is about to appear it makes sure everything is updated and reset for the next fish
    override func viewWillAppear(_ animated: Bool) {
        resetFish()
        
        checkBait()
        // Displays the view while waiting for the next bite
        toggleBoatHidden(false)
        // Starts the timer for the next fish
        fishAppearsTimer?.start()
    }
    
    
    private func generateRandomFish() {
        fish = Fish.generateRandomFish(from: location?.availableFish ?? FishType.allCases)
        
        guard let fish else { return }
        
        // Calculates how many spins are needed to acquire the fish
        requiredSpins = Int(fish.size)
                
        NSLog("Generated \(fish))")
    }
    
    /// haha your a bad fisherman. The fish you "almost" got is gone forever and totally reset for another random fish
    private func fishGotAway() {
        // I think this resets the fish😉
        resetFish()
        
        radarDisplayImageView.image = UIImage(named: "radar")

        hookTimer?.stop()
        catchTimeTimer?.stop()
        
        // Gives you 5 seconds to contemplate your fisherman skills
        catchTimeTimer = CatchTimeTimer(countdownTime: 5) { timeSinceStart in
            let timeRemaining = TimeInterval(5) - timeSinceStart
            self.timeRemainingLabel.text = "Missed... \(timeRemaining.rounded(toPlaces: 1))"
        } completionHandler: {
            // resets everything after losing
            self.timeRemainingLabel.text = ""
            self.checkBait()
            self.toggleBoatHidden(false)
            self.fishAppearsTimer?.start()
        }
        
        self.catchTimeTimer?.start()
    }
    
    // Switches elements to show the fish took a bite "view"
    private func showFishAppeared() {
        fishHasAppeared = true
        toggleBoatHidden(true)
        timeRemainingLabel.text = "!!!"
        radarDisplayImageView.image = UIImage(named: "fishAppeared")
    }
    
    // You have a certain amount of time that is calculated based on the fish before it gets away
    private func startHookTimer() {
        hookTimer = HookTimer() {
            self.fishGotAway()
        }
        
        hookTimer?.start()
    }
    
    // The fish is hooked now the user needs to reel it in
    private func startReelingFish() {
        hookTimer?.stop()
        
        fishHasAppeared = false
        reelingInFish = true
        radarDisplayImageView.image = UIImage(named: "fishHooked")
        
        totalRotationAngle = 0
        moveReelToOrigin()
        
        startCatchCountdown()
    }
    
    /// Starts the timer for how long you have to reel before the fish escapes
    func startCatchCountdown() {
        //gets catch time
        let catchTime = calculateCatchTime()
        
        // starts catch time
        catchTimeTimer = CatchTimeTimer(countdownTime: catchTime) { timeSinceStart in
            //counts down timer
            let timeRemaining = catchTime - timeSinceStart
            // updates timer label
            self.timeRemainingLabel.text = "⏱️ \(Int(timeRemaining.rounded(toPlaces: 1)))s"
        } completionHandler: {
            // if time runs out fish gets away
            self.fishGotAway()
        }
        
        catchTimeTimer?.start()
    }
    
    // Depending on the fishing line, you get extra time for reeling
    func calculateCatchTime() -> TimeInterval {
        let baseCatchTime = TimeInterval(20)
        
        var bonusCatchTime: TimeInterval {
            switch tacklebox.line {
            case .twine:
                return 0
            case .monofilament:
                return 5
            case .fluorocarbon:
                return 10
            }
        }
        
        return baseCatchTime + bonusCatchTime
    }
    
    /// Called when the reel is complete
    func catchFish() {
        self.reelingInFish = false
        self.timeRemainingLabel.text = ""
        catchTimeTimer?.stop()
        moveReelToDefaultNoFishPosition()
        transitionToCatchScreen()
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
                location.locationCaughtFish = LocationCaughtFish(location: location, caughtFish: Set(caughtFish.map({$0.type})))
            }
                    
            let record = location.locationCaughtFish!

            // Filter new, unique fish types
            let newFishTypes = caughtFish
                .map { $0.type }
                .filter { !record.caughtFish.contains($0) }

            // Update the record
            record.caughtFish.formUnion(newFishTypes)
            LocationService.shared.save()
            // Need to refactor saving and loading still
        }
        
        // Sends you to the corresponding view
        if early {
            self.performSegue(withIdentifier: "OutOfBaitSegue", sender: nil)
        } else {
            self.performSegue(withIdentifier: "ShowSummarySegue", sender: nil)
        }
    }
    
    // Uses one bait when a fish bites
    func useBait() {
        print("Used bait")
        
        tacklebox.baitCount -= 1
        TackleboxService.shared.save()
        baitRemainingLabel.text = "Bait Remaining: \(tacklebox.baitCount)"
    }
    
    // If bait reaches 0, the day will end
    func checkBait() {
        if tacklebox.baitCount <= 0 {
            endDay(early: true)
        }
    }
    
    // Toggles the boat's visibility on screen
    func toggleBoatHidden(_ hidden: Bool) {
        self.boatImageView.isHidden = hidden
        
        self.radarDisplayImageView.isHidden = !hidden
        self.fishingProgressImageView.isHidden = !hidden
        self.spinningReelImageView.isHidden = !hidden
        self.distanceToFishLabel.isHidden = !hidden
        self.timeRemainingLabel.isHidden = !hidden
    }
    
    func resetFish() {
        self.reelingInFish = false
        self.fishHasAppeared = false
        self.fish = nil
        self.totalRotationAngle = 0
        self.previousTouchPoint = CGPoint()
        self.reelProgress = 0
        self.requiredSpins = 0
    }
    
    // Handles reeling with your finger
    @IBAction func panGestured(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view, sender.numberOfTouches > 0 else { return }
        
        // Ensures that there is a fish and that reeling is in progress
        guard fishHasAppeared || reelingInFish else { return }
        
        if fishHasAppeared {
            startReelingFish()
        }
        // Records the current touch location
        let currentTouchPoint = sender.location(ofTouch: 0, in: view)
            // Updates the current touch point
        if sender.state == .began {
            previousTouchPoint = currentTouchPoint
        } else if sender.state == .changed {
            // Advances the progress as the reel is spun
            spinReel(currentTouchPoint: currentTouchPoint)
            updateFishingProgress()
            previousTouchPoint = currentTouchPoint
            
            // If you meet the reel requirement, then you catch the fish
            if totalRotations >= requiredSpins {
                catchFish()
            }
        }
    }
    
    // Updates the tackle box with additional cash
    private func transitionToCatchScreen() {
        TackleboxService.shared.tacklebox.cash += caughtFish.reduce(0) { $0 + Int($1.price) }
        TackleboxService.shared.save()
        performSegue(withIdentifier: "fishCaughtSegue", sender: self)
    }
    
    // Updates the list of caught fish
    @IBAction func unwindSegue(for: UIStoryboardSegue, sender: Any?) {
        if let fish {
            caughtFish.append(fish)
        }
    }
    // Determines which screen to navigate to
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fishCaughtSegue" {
            guard let destination = segue.destination as? FishCaughtViewController else { return }
            
            destination.fish = self.fish
        } else if segue.identifier == "ShowSummarySegue" {
            
            
            guard let destination = segue.destination as? SummaryScreenViewController else { return }
            
            destination.caughtFish = self.caughtFish
        }
    }
}

extension FishingScreenViewController {

    private func spinReel(currentTouchPoint: CGPoint) {
        let centerOfReel = spinningReelImageView.center
        
        let fingerMovementAngle = calculateFingerMovementAngle(currentTouchPoint, centerOfReel)
            
        if fingerMovementAngle >= 0 && fingerMovementAngle <= 1 { // Range limits the speed you can spin; probably a better solution for this
            spinningReelImageView.transform = spinningReelImageView.transform.concatenating(CGAffineTransform(rotationAngle: fingerMovementAngle))
            
            totalRotationAngle += fingerMovementAngle
        }
    }
    
    // Calculates the angle of your reeling gesture
    private func calculateFingerMovementAngle(_ currentTouchPoint: CGPoint, _ centerOfReel: CGPoint) -> CGFloat {
        return atan2(currentTouchPoint.y - centerOfReel.y, currentTouchPoint.x - centerOfReel.x) - atan2(previousTouchPoint.y - centerOfReel.y, previousTouchPoint.x - centerOfReel.x)
    }
    
    // Updates how much left to catch fish and animates the reel
    private func updateFishingProgress() {
        distanceToFishLabel.text = "\(totalRotations)/\(requiredSpins)"
        
        animateReelProgress()
    }
    
    /// Animates the reel according to your gestures
    private func animateReelProgress() {
        guard let image = fishingProgressImageView.image else { return }
        
        // Create the constants
        let progress = Double(totalRotations) / Double(requiredSpins)
        let imageHeight = image.size.height
        let clippingBoundsHeight = fishingProgressImageView.frame.height
                
        let imageToClippingBoundsRatio = clippingBoundsHeight / imageHeight
        let imageOffsetForCurrentProgress = 2 * ((progress * clippingBoundsHeight) / imageHeight)
        let changeInOffsetForCurrentProgress = reelProgress.distance(to: (imageToClippingBoundsRatio - imageOffsetForCurrentProgress))
        
        let currentPositionOfContentsRect = fishingProgressImageView.layer.contentsRect
                
        // Animates the progress and reel
        UIView.animate(withDuration: 0.1) {
            self.fishingProgressImageView.layer.contentsRect = currentPositionOfContentsRect.applying(CGAffineTransform(translationX: 0, y: changeInOffsetForCurrentProgress))        }
        
        reelProgress += changeInOffsetForCurrentProgress
    }
    
    // Resets the reel to its default position when no fish is present
    private func moveReelToDefaultNoFishPosition() {
        let defaultRectForNoFish = CGRect(x: 0, y: -0.25, width: 1, height: 1)
        
        self.fishingProgressImageView.layer.contentsRect = defaultRectForNoFish
    }
    
    // Resets the reel to the origin
    private func moveReelToOrigin() {
        reelProgress = 0
        let originRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        self.fishingProgressImageView.layer.contentsRect = originRect
    }
    
}
