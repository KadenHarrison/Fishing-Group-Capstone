//
//  Tacklebox.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/26/25.
//

import Foundation

protocol TackleboxRepository {
    func loadTacklebox() throws -> Tacklebox
    func saveTacklebox(_ tacklebox: Tacklebox) throws
}

// Enums are able to use the upgrade functions
protocol Upgradable: RawRepresentable, CaseIterable where RawValue == Int {
    mutating func upgrade()
    var next: Self? { get }
}

// Enums can show the next upgrade available for the player to purchase
protocol Displayable {
    var displayName: String { get }
}

// Adds functionality to the Upgradable protocol
extension Upgradable {
    var next: Self? {
        return Self(rawValue: rawValue + 1)
    }

    mutating func upgrade() {
        if let nextValue = next {
            self = nextValue
        }
    }
}


class FileTackleboxRepository: TackleboxRepository {
    func loadTacklebox() throws -> Tacklebox {
        guard let tacklebox = try SaveDataManager.shared.load(Tacklebox.self, forKey: "tacklebox") else {
            return Tacklebox()
        }
        return tacklebox
    }
    
    func saveTacklebox(_ tacklebox: Tacklebox) throws {
        try SaveDataManager.shared.save(tacklebox, forKey: "tacklebox")
    }
}

class Tacklebox: Codable {
    var cash: Int
    var baitCount: Int
    var hook: Hook
    var line: Line
    var boat: Boat
    var fishingLicense: FishingLicense
    /// Inventory Upgrades
    var hasCoffee: Bool = false
    var hasReelSpeedUp: Bool = false
    var hasRarityLure: Bool = false
    var hasLargeLure: Bool = false
    var spaceBait: Int = 0
    
    init(cash: Int = 0,
         baitCount: Int = 10,
         hook: Hook = .carvedWood,
         line: Line = .twine,
         boat: Boat = .canoe,
         fishingLicense: FishingLicense = .mountain
    ) {
        self.cash = cash
        self.baitCount = baitCount
        self.hook = hook
        self.line = line
        self.boat = boat
        self.fishingLicense = fishingLicense
    }
}

enum Hook: Int, Codable, CaseIterable, Upgradable, Displayable {
    case carvedWood, plastic, steel
    
    var displayName: String {
        switch self {
        case .carvedWood: return "Carved Wood"
        case .plastic: return "Plastic"
        case .steel: return "Steel"
        }
    }
}

enum Line: Int, Codable, CaseIterable, Upgradable, Displayable {
    case twine, monofilament, fluorocarbon
    
    var displayName: String {
        switch self {
        case .twine: return "Twine"
        case .monofilament: return "Monofilament"
        case .fluorocarbon: return "Fluorocarbon"
        }
    }
}

enum Boat: Int, Codable, CaseIterable, Upgradable, Displayable {
    case rowboat, canoe, sailboat, submarine
    
    var displayName: String {
        switch self {
        case .rowboat: return "Rowboat"
        case .canoe: return "Canoe"
        case .sailboat: return "Sailboat"
        case .submarine: return "Submarine"
        }
    }
}

enum FishingLicense: Int, Codable, CaseIterable, Upgradable, Displayable {
    case mountain, river, valley, shore, deepSea
    
    var displayName: String {
        switch self {
        case .mountain: return "Mountain"
        case .river: return "River"
        case .valley: return "Valley"
        case .shore: return "Shore"
        case .deepSea: return "Deep Sea"
        }
    }
    /// Determines the locations the player can fish at based on the different liscenses they have in their tacklebox
    mutating func upgrade() {
        guard let nextLicense = FishingLicense(rawValue: self.rawValue + 1) else { return }
        
        self = nextLicense
    }
}
