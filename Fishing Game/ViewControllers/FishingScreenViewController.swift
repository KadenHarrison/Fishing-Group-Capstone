//
//  FishingScreenViewController.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/2/25.
//

import UIKit

class FishingScreenViewController: UIViewController {
    var location: Location?
    
    private let tacklebox = Tacklebox.shared
    
    private var fishAppearsTimer: FishAppearsTimer?
    private var hookTimer: HookTimer?
    private var catchTimeTimer: CatchTimeTimer?
    private var dayCycleTimer: DayCycleTimer?
    
    private var fishHasAppeared = false
    private var reelingInFish = false
    private var fish: Fish? = nil
    private var caughtFish: [Fish] = []
    private var requiredSpins = 0
    private var reelProgress = 0.0
    
    private var previousTouchPoint = CGPoint()
    private var totalRotationAngle: CGFloat = 0
    private var totalRotations: Int {
        Int(Double(totalRotationAngle) / (2.0 * Double.pi))
    }
    
    @IBOutlet weak var boatImageView: UIImageView!
    @IBOutlet weak var radarDisplayImageView: UIImageView!
    @IBOutlet weak var fishingProgressImageView: UIImageView!
    @IBOutlet weak var spinningReelImageView: UIImageView!
    
    @IBOutlet var gestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var distanceToFishLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var baitRemainingLabel: UILabel!
    
    @IBOutlet var clockLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        toggleBoatHidden(false)
        
        self.baitRemainingLabel.text = "Bait Remaining: \(tacklebox.baitCount)"
        
        self.boatImageView.image = UIImage(named: location?.backgroundName ?? "boat")
        
        self.radarDisplayImageView.image = UIImage(named: "radar")
        
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
        
        self.fishAppearsTimer = FishAppearsTimer(maxTime: maxTimeUntilFishAppears) {
            self.generateRandomFish()
            self.useBait()
            self.showFishAppeared()
            self.startHookTimer()
        }
                        
        if dayCycleTimer == nil {
            dayCycleTimer = DayCycleTimer(tickHandler: { timeSinceStart in
                
                print("TICK: \(timeSinceStart)")
                // Calculate "time of day" where 0 is 9:00 AM, every 15 seconds 1 hour passes, day ends at midnight
                let timeOfDay = 9.0 + (timeSinceStart.rounded(toPlaces: 1) / 15)
                
                let amOrPm = timeOfDay >= 12.0 ? "PM" : "AM"
                
                let formattedTime = "\(Int(timeOfDay) % 12 == 0 ? 12 : Int(timeOfDay) % 12):00 \(amOrPm)"
                
                self.clockLabel.text = formattedTime
            }, completionHandler: {
                self.endDay(early: false)
            })
            
            dayCycleTimer?.start()
        }
        
        moveReelToDefaultNoFishPosition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetFish()
        
        checkBait()
        
        toggleBoatHidden(false)
        fishAppearsTimer?.start()
    }
    
    private func generateRandomFish() {
        fish = Fish.generateRandomFish(from: location?.availableFish ?? FishType.allCases)
        
        guard let fish else { return }
        
        requiredSpins = Int(fish.size)
                
        NSLog("Generated \(fish))")
    }
    
    private func fishGotAway() {
        resetFish()
        
        radarDisplayImageView.image = UIImage(named: "radar")

        hookTimer?.stop()
        catchTimeTimer?.stop()
        
        catchTimeTimer = CatchTimeTimer(countdownTime: 5) { timeSinceStart in
            let timeRemaining = TimeInterval(5) - timeSinceStart
            self.timeRemainingLabel.text = "Missed... \(timeRemaining.rounded(toPlaces: 1))"
        } completionHandler: {
            self.timeRemainingLabel.text = ""
            self.checkBait()
            self.toggleBoatHidden(false)
            self.fishAppearsTimer?.start()
        }
        
        self.catchTimeTimer?.start()
    }
    
    private func showFishAppeared() {
        fishHasAppeared = true
        toggleBoatHidden(true)
        timeRemainingLabel.text = "!!!"
        radarDisplayImageView.image = UIImage(named: "fishAppeared")
    }
        
    private func startHookTimer() {
        hookTimer = HookTimer() {
            self.fishGotAway()
        }
        
        hookTimer?.start()
    }
    
    private func startReelingFish() {
        hookTimer?.stop()
        
        fishHasAppeared = false
        reelingInFish = true
        radarDisplayImageView.image = UIImage(named: "fishHooked")
        
        totalRotationAngle = 0
        moveReelToOrigin()
        
        startCatchCountdown()
    }
    
    func startCatchCountdown() {
        let catchTime = calculateCatchTime()
        
        catchTimeTimer = CatchTimeTimer(countdownTime: catchTime) { timeSinceStart in
            let timeRemaining = catchTime - timeSinceStart
            self.timeRemainingLabel.text = "⏱️ \(Int(timeRemaining.rounded(toPlaces: 1)))s"
        } completionHandler: {
            self.fishGotAway()
        }
        
        catchTimeTimer?.start()
    }
    
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
    
    func catchFish() {
        self.reelingInFish = false
        self.timeRemainingLabel.text = ""
        catchTimeTimer?.stop()
        moveReelToDefaultNoFishPosition()
        transitionToCatchScreen()
    }
    
    func endDay(early: Bool) {
        self.fishAppearsTimer?.stop()
        self.catchTimeTimer?.stop()
        self.dayCycleTimer?.stop()
        
        if let location {
            let newFish = caughtFish.filter { fish in
                !location.caughtFish.contains { $0 == fish.type }
            }
            
            let newFishTypes = newFish.map { fish in
                return fish.type
            }
            
            location.caughtFish.append(contentsOf: newFishTypes)
            
            Location.save()
        }
        
        if early {
            self.performSegue(withIdentifier: "OutOfBaitSegue", sender: nil)
        } else {
            self.performSegue(withIdentifier: "ShowSummarySegue", sender: nil)
        }
    }
    
    func useBait() {
        print("Used bait")
        
        tacklebox.baitCount -= 1
        Tacklebox.save()
        baitRemainingLabel.text = "Bait Remaining: \(tacklebox.baitCount)"
    }
    
    func checkBait() {
        if tacklebox.baitCount <= 0 {
            endDay(early: true)
        }
    }
    
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
    
    @IBAction func panGestured(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view, sender.numberOfTouches > 0 else { return }
        
        guard fishHasAppeared || reelingInFish else { return }
        
        if fishHasAppeared {
            startReelingFish()
        }
        
        let currentTouchPoint = sender.location(ofTouch: 0, in: view)
        
        if sender.state == .began {
            previousTouchPoint = currentTouchPoint
        } else if sender.state == .changed {
            spinReel(currentTouchPoint: currentTouchPoint)
            updateFishingProgress()
            previousTouchPoint = currentTouchPoint
            
            if totalRotations >= requiredSpins {
                catchFish()
            }
        }
    }
    
    private func transitionToCatchScreen() {
        Tacklebox.shared.cash += caughtFish.reduce(0) { $0 + Int($1.price) }
        Tacklebox.save()
        performSegue(withIdentifier: "fishCaughtSegue", sender: self)
    }
    
    @IBAction func unwindSegue(for: UIStoryboardSegue, sender: Any?) {
        if let fish {
            caughtFish.append(fish)
        }
    }
    
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
    
    private func calculateFingerMovementAngle(_ currentTouchPoint: CGPoint, _ centerOfReel: CGPoint) -> CGFloat {
        return atan2(currentTouchPoint.y - centerOfReel.y, currentTouchPoint.x - centerOfReel.x) - atan2(previousTouchPoint.y - centerOfReel.y, previousTouchPoint.x - centerOfReel.x)
    }
    
    private func updateFishingProgress() {
        distanceToFishLabel.text = "\(totalRotations)/\(requiredSpins)"
        
        animateReelProgress()
    }
    
    private func animateReelProgress() {
        guard let image = fishingProgressImageView.image else { return }
        
        let progress = Double(totalRotations) / Double(requiredSpins)
        let imageHeight = image.size.height
        let clippingBoundsHeight = fishingProgressImageView.frame.height
                
        let imageToClippingBoundsRatio = clippingBoundsHeight / imageHeight
        let imageOffsetForCurrentProgress = 2 * ((progress * clippingBoundsHeight) / imageHeight)
        let changeInOffsetForCurrentProgress = reelProgress.distance(to: (imageToClippingBoundsRatio - imageOffsetForCurrentProgress))
        
        let currentPositionOfContentsRect = fishingProgressImageView.layer.contentsRect
                
        UIView.animate(withDuration: 0.1) {
            self.fishingProgressImageView.layer.contentsRect = currentPositionOfContentsRect.applying(CGAffineTransform(translationX: 0, y: changeInOffsetForCurrentProgress))        }
        
        reelProgress += changeInOffsetForCurrentProgress
    }
    
    private func moveReelToDefaultNoFishPosition() {
        let defaultRectForNoFish = CGRect(x: 0, y: -0.25, width: 1, height: 1)
        
        self.fishingProgressImageView.layer.contentsRect = defaultRectForNoFish
    }
    
    private func moveReelToOrigin() {
        reelProgress = 0
        let originRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        self.fishingProgressImageView.layer.contentsRect = originRect
    }
    
}
