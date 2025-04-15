//
//  FishAppearsTimer.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/13/25.
//

import Foundation

class FishAppearsTimer {
    var maxTime: TimeInterval
    
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0
    private let timeInterval: TimeInterval = 1
    private let eventHandler: () -> Void
    
    init(maxTime: TimeInterval, eventHandler: @escaping () -> Void) {
        self.maxTime = maxTime
        self.eventHandler = eventHandler
    }
    
    func start() {
        stop()
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
    }
    
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

class HookTimer {
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0
    private let timeInterval: TimeInterval = 0.1
    private var maxTime: TimeInterval = 0
    private let completionHandler: () -> Void
    
    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    
    func start() {
            stop()
        
        self.maxTime = TimeInterval.random(in: 1...3)
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true ) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        elapsedTime += timeInterval
                
        if elapsedTime > maxTime {
            completionHandler()
            stop()
        }
    }
}

class CatchTimeTimer {
    private var timer: Timer?
    private var startTime = Date.now
    private var countdownTime: TimeInterval = 0
    private let timeInterval: TimeInterval = 0.1
    private let tickHandler: (TimeInterval) -> Void
    private let completionHandler: () -> Void
    
    init(countdownTime: TimeInterval, tickHandler: @escaping (TimeInterval) -> Void, completionHandler: @escaping () -> Void) {
        self.countdownTime = countdownTime
        self.tickHandler = tickHandler
        self.completionHandler = completionHandler
    }
    
    func start() {
        stop()
        startTime = Date.now
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        let timeSinceStart = Date.now.timeIntervalSince(startTime)
        
        self.tickHandler(timeSinceStart)
        
        if timeSinceStart > countdownTime {
            completionHandler()
            stop()
        }
    }
}

class DayCycleTimer {    
    private var timer: Timer?
    private var startTime = Date.now
    private var countdownTime: TimeInterval = 225
    private let timeInterval: TimeInterval = 15
    private let tickHandler: (TimeInterval) -> Void
    private let completionHandler: () -> Void
    
    init(tickHandler: @escaping (TimeInterval) -> Void, completionHandler: @escaping () -> Void) {
        self.tickHandler = tickHandler
        self.completionHandler = completionHandler
    }
    
    func start() {
        stop()
        startTime = Date.now
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        let timeSinceStart = Date.now.timeIntervalSince(startTime)
        
        self.tickHandler(timeSinceStart)
        
        if timeSinceStart > countdownTime {
            completionHandler()
            stop()
        }
    }
}
