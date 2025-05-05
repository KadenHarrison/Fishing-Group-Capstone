//
//  FishingScreenViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/2/25.

import UIKit

class FishingScreenViewController: UIViewController {
    
    #if DEBUG
    var isDebugFastReelEnabled = true
    #else
    let isDebugFastReelEnabled = false
    #endif
    
    var fishingDay = FishingDay()
    var fishingReel = FishingReel()
    
    
    // Tracks the progress and current state of the player
    var fishHasAppeared = false
    var reelingInFish = false
    var fish: Fish? = nil
    
    
    // Tracks how many times the rod has been rotated by the user
    var previousTouchPoint = CGPoint()
    var totalRotationAngle: CGFloat = 0
    var totalRotations: Int {
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
    @IBOutlet weak var baitImage: UIImageView!
    
    @IBOutlet weak var baitViewsHStack: UIStackView!
    @IBOutlet weak var fishingProgressView: UIImageView!
    @IBOutlet weak var fishRadarView: UIImageView!
    
    // Displays your progress in the game
    @IBOutlet var clockLabel: UILabel!
    
    override func viewDidLoad() {
        fishingProgressView.layer.cornerRadius = 10
        fishRadarView.layer.cornerRadius = 10
        baitImage.layer.borderWidth = 2
        baitImage.layer.cornerRadius = baitImage.frame.height / 2
        baitImage.layer.shadowColor = UIColor.black.cgColor
        baitImage.layer.shadowOpacity = 0.4
        baitImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        baitImage.layer.shadowRadius = 6
        
        baitViewsHStack.isLayoutMarginsRelativeArrangement = true
        baitViewsHStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 20)

        for subview in baitViewsHStack.arrangedSubviews {
            if let label = subview as? UILabel {
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            }
        }

        baitViewsHStack.layer.cornerRadius = baitViewsHStack.frame.height / 2
        baitViewsHStack.layer.borderWidth = 1
        baitViewsHStack.layer.borderColor = UIColor.white.cgColor
        baitViewsHStack.layer.shadowColor = UIColor.black.cgColor
        baitViewsHStack.layer.shadowOpacity = 0.3
        baitViewsHStack.layer.shadowOffset = CGSize(width: 0, height: 1)
        baitViewsHStack.layer.shadowRadius = 4
        
        fishingReel.viewController = self
        fishingReel.fishingDay = fishingDay
        
        super.viewDidLoad()
        fishingDay.delegate = self
        // Shows the screen while waiting for a fish
        toggleBoatHidden(false)
        
        // Updates the displayed bait count
        self.baitRemainingLabel.text = "Bait Remaining: \(String(describing: fishingDay.tacklebox.baitCount))"
        
        // Sets the background image based on the fishing location
        self.boatImageView.image = UIImage(named: fishingDay.location?.backgroundName ?? "boat")
        
        // Loads the radar image
        self.radarDisplayImageView.image = UIImage(named: "radar")
        
        // Determines the maximum time for a fish to bite based on the hook type
        var maxTimeUntilFishAppears: TimeInterval {
            switch fishingDay.tacklebox.hook {
            case .carvedWood:
                return 60
            case .plastic:
                return 50
            case .steel:
                return 40
            }
        }
        
        // Starts the timer for the next fish appearance
        fishingDay.fishAppearsTimer = FishAppearsTimer(maxTime: maxTimeUntilFishAppears) {
            self.fishingReel.generateRandomFish()
            self.fishingReel.useBait()
            self.showFishAppeared()
            self.fishingReel.startHookTimer()
        }
        
        
        
        moveReelToDefaultNoFishPosition()
    }
    
    /// When the view is about to appear it makes sure everything is updated and reset for the next fish
    override func viewWillAppear(_ animated: Bool) {
        fishingReel.resetFish()
        
            fishingDay.checkBait()
        // Displays the view while waiting for the next bite
        toggleBoatHidden(false)
        // Starts the timer for the next fish
        fishingDay.fishAppearsTimer?.start()
    }
    

    
    // Switches elements to show the fish took a bite "view"
    func showFishAppeared() {
        fishHasAppeared = true
        toggleBoatHidden(true)
        timeRemainingLabel.text = "!!!"
        radarDisplayImageView.image = UIImage(named: "fishAppeared")
    }
    
    
    
    // The fish is hooked now the user needs to reel it in
    func startReelingFish() {
        fishingReel.hookTimer?.stop()
        
        fishHasAppeared = false
        reelingInFish = true
        radarDisplayImageView.image = UIImage(named: "fishHooked")
        
        totalRotationAngle = 0
        moveReelToOrigin()
        
        fishingReel.startCatchCountdown()
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
            spinReel(currentTouchPoint: currentTouchPoint)

            if isDebugFastReelEnabled && sender.numberOfTouches == 1 {
                totalRotationAngle += .pi // Adds a half spin for debug fun, but not too fast
            }

            updateFishingProgress()
            previousTouchPoint = currentTouchPoint

            if totalRotations >= fishingReel.requiredSpins {
                fishingReel.catchFish()
            }
        }
    }
    
    // Updates the tackle box with additional cash
    func transitionToCatchScreen() {
        Tacklebox.shared.cash += fishingDay.caughtFish.reduce(0) { $0 + Int($1.price) }
        Tacklebox.save()
        performSegue(withIdentifier: "fishCaughtSegue", sender: self)
    }
    
    // Updates the list of caught fish
    @IBAction func unwindSegue(for: UIStoryboardSegue, sender: Any?) {
        if let fish {
            fishingDay.caughtFish.append(fish)
        }
    }
    // Determines which screen to navigate to
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fishCaughtSegue" {
            guard let destination = segue.destination as? FishCaughtViewController else { return }
            
            destination.fish = self.fish
        } else if segue.identifier == "ShowSummarySegue" {
            
            
            guard let destination = segue.destination as? SummaryScreenViewController else { return }
            
            destination.caughtFish = self.fishingDay.caughtFish
        }
    }
}

extension FishingScreenViewController: FishingDayDelegate {
    func dayTimeUpdated(time: String) {
        self.clockLabel.text = time
    }
    
    // Sends you to the corresponding view
    func handleEndOfDay(isEarly: Bool) {
        if isEarly {
            self.performSegue(withIdentifier: "OutOfBaitSegue", sender: nil)
        } else {
            self.performSegue(withIdentifier: "ShowSummarySegue", sender: nil)
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
        distanceToFishLabel.text = "\(totalRotations)/\(fishingReel.requiredSpins)"
        
        animateReelProgress()
    }
    
    /// Animates the reel according to your gestures
    private func animateReelProgress() {
        guard let image = fishingProgressImageView.image else { return }
        
        // Create the constants
        let progress = Double(totalRotations) / Double(fishingReel.requiredSpins)
        let imageHeight = image.size.height
        let clippingBoundsHeight = fishingProgressImageView.frame.height
        
        let imageToClippingBoundsRatio = clippingBoundsHeight / imageHeight
        let imageOffsetForCurrentProgress = 2 * ((progress * clippingBoundsHeight) / imageHeight)
        let changeInOffsetForCurrentProgress = fishingReel.reelProgress.distance(to: (imageToClippingBoundsRatio - imageOffsetForCurrentProgress))
        
        let currentPositionOfContentsRect = fishingProgressImageView.layer.contentsRect
        
        // Animates the progress and reel
        UIView.animate(withDuration: 0.1) {
            self.fishingProgressImageView.layer.contentsRect = currentPositionOfContentsRect.applying(CGAffineTransform(translationX: 0, y: changeInOffsetForCurrentProgress))        }
        
        fishingReel.reelProgress += changeInOffsetForCurrentProgress
    }
    
    // Resets the reel to its default position when no fish is present
    func moveReelToDefaultNoFishPosition() {
        let defaultRectForNoFish = CGRect(x: 0, y: -0.25, width: 1, height: 1)
        
        self.fishingProgressImageView.layer.contentsRect = defaultRectForNoFish
    }
    
    // Resets the reel to the origin
    func moveReelToOrigin() {
        fishingReel.reelProgress = 0
        let originRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        self.fishingProgressImageView.layer.contentsRect = originRect
    }
    
}
