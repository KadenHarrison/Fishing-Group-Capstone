//
//  FishAppearsTimer.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/13/25.
//

import Foundation

// MARK: GameTimer
/// Ensures each timer has a start and stop function.
protocol GameTimer {
    func start()
    func stop()
}

// MARK: BaseTimer
/// Base timer that repeatedly calls a provided closure at a fixed time interval. Intended to be reused by higher-level timers to encapsulate timer logic.
class BaseTimer {
    private var timer: Timer?
    private var timeInterval: TimeInterval
    /// The closure to execute on each timer tick.
    private var onTick: (() -> Void)?
    
    /// Initializes a new `BaseTimer` with a specified interval between ticks.
    /// - Parameter timeInterval: The time (in seconds) between each timer tick.
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    /// Starts the timer, calling the provided closure at each interval. If the timer is already running, it is stopped and restarted.
    /// - Parameter onTick: The closure to execute on each timer tick.
    func start(onTick: @escaping () -> Void) {
        stop()
        self.onTick = onTick
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.onTick?()
        }
    }
    
    /// Stops the timer and invalidates any scheduled ticks.
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}


// MARK: FishAppearsTimer
/// A timer that gradually increases the probability of triggering a given event. Once triggered, the timer stops and resets.
class FishAppearsTimer: GameTimer {
    var maxTime: TimeInterval
    
    private var baseTimer = BaseTimer(timeInterval: 1)
    private var elapsedTime: TimeInterval = 0
    private let timeInterval: TimeInterval = 1
    private let eventHandler: () -> Void
    
    /// Initializes the timer.
    /// - Parameters:
    ///   - maxTime: The time after which the event is guaranteed to trigger.
    ///   - eventHandler: The closure to call when the event occurs.
    init(maxTime: TimeInterval, eventHandler: @escaping () -> Void) {
        self.maxTime = maxTime
        self.eventHandler = eventHandler
    }
    
    /// Starts the timer, resetting it if already active.
    func start() {
        baseTimer.start { [weak self] in self?.tick() }
    }
    
    /// Stops the timer and resets the elapsed time.
    func stop() {
        baseTimer.stop()
        elapsedTime = 0
    }
    
    /// Increments elapsed time and randomly decides if the event should trigger based on increasing probability. If triggered, stops the timer.
    private func tick() {
        elapsedTime += timeInterval
        let probability = min(elapsedTime / maxTime, 1.0)
        let diceRoll = Double.random(in: 0...1)

        if diceRoll < probability {
            eventHandler()
            stop()
        }
    }
}

// MARK: HookTimer
/// A timer that runs for a random duration between 1 and 3 seconds, then triggers a completion handler.
class HookTimer: GameTimer {
    private var baseTimer = BaseTimer(timeInterval: 0.1)
    private var elapsedTime: TimeInterval = 0
    private let timeInterval: TimeInterval = 0.1
    private var maxTime: TimeInterval = 0
    private let completionHandler: () -> Void
    
    /// Initializes the timer with a completion handler.
    /// - Parameter completionHandler: The closure to call when the timer completes.
    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    
    /// Starts the timer with a random max duration between 1 and 3 seconds. If already running, resets the timer.
    func start() {
        self.maxTime = TimeInterval.random(in: 1...3)
        
        baseTimer.start { [weak self] in self?.tick() }
    }
    
    /// Stops the timer and resets internal state.
    func stop() {
        baseTimer.stop()
        elapsedTime = 0
    }
    
    /// Increments elapsed time and triggers completion handler if maxTime is exceeded.
    private func tick() {
        elapsedTime += timeInterval
                
        if elapsedTime > maxTime {
            completionHandler()
            stop()
        }
    }
}

// MARK: CatchTimeTimer
/// A countdown timer that repeatedly reports elapsed time and calls a completion handler when finished.
class CatchTimeTimer: GameTimer {
    private var baseTimer = BaseTimer(timeInterval: 0.1)
    private var startTime = Date.now
    private var countdownTime: TimeInterval = 0
    private let timeInterval: TimeInterval = 0.1
    private let tickHandler: (TimeInterval) -> Void
    private let completionHandler: () -> Void
    
    /// Initializes the timer.
    /// - Parameters:
    ///   - countdownTime: Total time before completion handler is called.
    ///   - tickHandler: Called every tick with elapsed time.
    ///   - completionHandler: Called once countdown is complete.
    init(countdownTime: TimeInterval, tickHandler: @escaping (TimeInterval) -> Void, completionHandler: @escaping () -> Void) {
        self.countdownTime = countdownTime
        self.tickHandler = tickHandler
        self.completionHandler = completionHandler
    }
    
    /// Starts the countdown timer. If already running, resets it.
    func start() {
        startTime = Date.now
        
        baseTimer.start { [weak self] in self?.tick() }
    }
    
    /// Stops the timer.
    func stop() {
        baseTimer.stop()
    }
    
    /// Calls the tick handler with elapsed time and checks for countdown completion.
    private func tick() {
        let timeSinceStart = Date.now.timeIntervalSince(startTime)
        tickHandler(timeSinceStart)
        
        if timeSinceStart > countdownTime {
            completionHandler()
            stop()
        }
    }
}

// MARK: DayCycleTimer
/// Timer simulating a day/night cycle. Calls tick updates every 15 seconds and completes after a full cycle.
class DayCycleTimer: GameTimer {
    private var baseTimer = BaseTimer(timeInterval: 15)
    private var startTime = Date.now
    private var countdownTime: TimeInterval = 100 // Default full cycle time 225 CHANGE BEFORE PR!!
    private let timeInterval: TimeInterval = 15
    private let tickHandler: (TimeInterval) -> Void
    private let completionHandler: () -> Void
    
    /// Initializes the timer.
    /// - Parameters:
    ///   - tickHandler: Called every `timeInterval` with elapsed time.
    ///   - completionHandler: Called when the full cycle completes.
    init(tickHandler: @escaping (TimeInterval) -> Void, completionHandler: @escaping () -> Void) {
        self.tickHandler = tickHandler
        self.completionHandler = completionHandler
    }
    
    /// Starts the day cycle timer, resetting if already running.
    func start() {
        startTime = Date.now
        
        baseTimer.start { [weak self] in self?.tick() }
    }
    
    /// Stops the timer.
    func stop() {
        baseTimer.stop()
    }
    
    /// Calls the tick handler and checks for cycle completion.
    private func tick() {
        let timeSinceStart = Date.now.timeIntervalSince(startTime)
        tickHandler(timeSinceStart)
        
        if timeSinceStart > countdownTime {
            completionHandler()
            stop()
        }
    }
}

