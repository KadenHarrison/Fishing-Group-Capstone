//
//  Tacklebox.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/26/25.
//

import Foundation

class Tacklebox: Codable {
    var cash: Int
    var baitCount: Int
    var hook: Hook
    var line: Line
    var boat: Boat
    var fishingLicense: FishingLicense

    init(cash: Int = 0, baitCount: Int = 10, hook: Hook = .carvedWood, line: Line = .twine, boat: Boat = .canoe, fishingLicense: FishingLicense = .mountain) {
        self.cash = cash
        self.baitCount = baitCount
        self.hook = hook
        self.line = line
        self.boat = boat
        self.fishingLicense = fishingLicense
    }
    
    static var shared: Tacklebox = Tacklebox()
    
    static func load() {
        if let tacklebox = try? SaveDataManager.shared.loadTacklebox() {
            Tacklebox.shared = tacklebox
        }
    }
    
    static func save() {
        do {
            try SaveDataManager.shared.save(tacklebox: Tacklebox.shared)
        } catch {
            NSLog("Error saving tacklebox: \(error)")
        }
    }
}

enum Hook: Int, Codable {
    case carvedWood, plastic, steel
    
    var displayName: String {
        switch self {
        case .carvedWood:
            return "Carved Wood"
        case .plastic:
            return "Plastic"
        case .steel:
            return "Steel"
        }
    }
    
    mutating func upgrade() {
        guard let nextHook = Hook(rawValue: self.rawValue + 1) else { return }
        
        self = nextHook
    }
}

enum Line: Int, Codable {
    case twine, monofilament, fluorocarbon
    
    var displayName: String {
        switch self {
        case .twine:
            return "Twine"
        case .monofilament:
            return "Monofilament"
        case .fluorocarbon:
            return "Fluorocarbon"
        }
    }
    
    mutating func upgrade() {
        guard let nextLine = Line(rawValue: self.rawValue + 1) else { return }
        
        self = nextLine
    }
}

enum Boat: Int, Codable {
    case rowboat, canoe, sailboat, submarine
    
    var displayName: String {
        switch self {
        case .rowboat:
            return "Rowboat"
        case .canoe:
            return "Canoe"
        case .sailboat:
            return "Sailboat"
        case .submarine:
            return "Submarine"
        }
    }
    
    mutating func upgrade() {
        guard let nextBoat = Boat(rawValue: self.rawValue + 1) else { return }
        
        self = nextBoat
    }
}

enum FishingLicense: Int, Codable {
    case mountain, river, valley, shore, deepSea
    
    var displayName: String {
        switch self {
        case .mountain:
            return "Mountain"
        case .river:
            return "River"
        case .valley:
            return "Valley"
        case .shore:
            return "Shore"
        case .deepSea:
            return "Deep Sea"
        }
    }
    
    mutating func upgrade() {
        guard let nextLicense = FishingLicense(rawValue: self.rawValue + 1) else { return }
        
        self = nextLicense
    }
}
