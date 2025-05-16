//
//  Fish.swift
//  Fishing Game
//
//  Created by Jane Madsen on 1/29/25.
//

import Foundation
import UIKit

enum Rarity: String, Codable {
    case normal, rare, junk
}

enum JunkType: String, Codable, CaseIterable {
    case newspaper, oldBoot, tire, glassBottle, plasticBag, gold, seaweed, oldCan, ring
    
    var price: Double {
        switch self {
        case .newspaper:
            return 1.0
        case .oldBoot:
            return 5.0
        case .tire:
            return 10.0
        case .glassBottle:
            return 5.0
        case .plasticBag:
            return 1.0
        case .gold:
            return 100.0
        case .seaweed:
            return 1.0
        case .oldCan:
            return 2.0
        case .ring:
            return 25.0
        }
    }
}

enum FishType: String, Codable, CaseIterable {
    case salmon, trout, cod, tuna, perch, catfish, bass, loach, piranha, anglerfish, eel, bluegill, carp, koi, walleye, spacefish
    
    /// Base price for each fish type
    var basePrice: Double {
        switch self {
        case .salmon:
            return 10.0
        case .trout:
            return 12.0
        case .cod:
            return 8.0
        case .tuna:
            return 30.0
        case .perch:
            return 5.0
        case .catfish:
            return 20.0
        case .bass:
            return 15.0
        case .loach:
            return 9.0
        case .piranha:
            return 18.0
        case .anglerfish:
            return 45.0
        case .eel:
            return 30.0
        case .bluegill:
            return 5.0
        case .carp:
            return 10.0
        case .koi:
            return 20.0
        case .walleye:
            return 11.0
        case .spacefish:
            return 1000.0
        }
    }
    
    // Size range for each fish types
    var sizeRange: (average: ClosedRange<Double>, rare: ClosedRange<Double>) {
        switch self {
        case .salmon:
            return (average: 20.0...30.0, rare: 15.0...60.0)
        case .trout:
            return (average: 12.0...20.0, rare: 8.0...35.0)
        case .cod:
            return (average: 20.0...30.0, rare: 15.0...50.0)
        case .tuna:
            return (average: 40.0...70.0, rare: 30.0...100.0)
        case .perch:
            return (average: 6.0...12.0, rare: 4.0...20.0)
        case .catfish:
            return (average: 15.0...25.0, rare: 10.0...60.0)
        case .bass:
            return (average: 12.0...22.0, rare: 8.0...30.0)
        case .loach:
            return (average: 3.0...6.0, rare: 2.0...12.0)
        case .piranha:
            return (average: 8.0...14.0, rare: 5.0...20.0)
        case .anglerfish:
            return (average: 6.0...12.0, rare: 5.0...20.0)
        case .eel:
            return (average: 20.0...40.0, rare: 15.0...60.0)
        case .bluegill:
            return (average: 5.0...10.0, rare: 3.0...15.0)
        case .carp:
            return (average: 15.0...25.0, rare: 10.0...40.0)
        case .koi:
            return (average: 12.0...18.0, rare: 8.0...30.0)
        case .walleye:
            return (average: 15.0...25.0, rare: 10.0...35.0)
        case .spacefish:
            return (average: 50.0...100.0, rare: 20.0...500.0)
        }
    }
}

struct Junk: Codable {
    var type: JunkType
    var rarity: Rarity
    var price: Double {
        return type.price
    }
    
    var description: String {
        "\(rarity.rawValue.capitalized) \(type.rawValue.capitalized)"
    }
    
    init(type: JunkType, rarity: Rarity) {
        self.type = type
        self.rarity = rarity
    }
}

/// Helper extension to get correct size range
extension FishType {
    func sizeRangeFor(rarity: Rarity) -> ClosedRange<Double> {
        switch rarity {
        case .normal:
            return self.sizeRange.average
        case .rare:
            return self.sizeRange.rare
        case .junk:
            return 0...0
        }
    }
}

/// This detirmines what fish it is and how rare and big the fish is and gets the price from 10% of fish type base price and the random size
struct Fish: Codable, CustomStringConvertible {
    // Data needed to create the fish. price is 10% of base price times size as a general pricing for fish
    var type: FishType
    var rarity: Rarity
    var size: Double
    var price: Double {
        return type.basePrice * size * 0.1
    }
    
    // Auto creates the description from other values
    var description: String {
        "\(rarity.rawValue.capitalized) \(type.rawValue.capitalized), size \(size)"
    }
    
    init(type: FishType, rarity: Rarity, size: Double) {
        self.type = type
        self.rarity = rarity
        self.size = size
    }
    
    var image: UIImage? {
        UIImage(named: self.type.rawValue)
    }
    
    static var fishAppearedImage: UIImage {
        UIImage(named: "fishAppeared")!
    }
}


class FishFactory {
    // Generates the data from helper functions
    static func generateRandomFish(from types: [FishType], rarity: Rarity) -> Fish {
        let type = types.randomElement() ?? .salmon
        let size = randomSize(rarity: rarity, fishType: type)
        
        return Fish(type: type, rarity: rarity, size: size)
    }
    
    static func generateRandomJunk(from types: [JunkType]) -> Junk {
        let type = types.randomElement() ?? .newspaper
        let rarity = Rarity.junk
        
        return Junk(type: type, rarity: rarity)
    }
    
    /// Gets the fishes rarity based on a random int generator
    static func randomRarity() -> Rarity {
        let r = Int.random(in: 1...100)
        
        if r < 85 && r > 25 {
            return .normal
        } else if r >= 85 {
            return .rare
        } else {
            return .junk
        }
    }
    
    /// Creates a random size for the fish
    static func randomSize(rarity: Rarity, fishType: FishType) -> Double {
        Double.random(in: rarity == .normal ? fishType.sizeRange.average : fishType.sizeRange.rare)
    }
}
