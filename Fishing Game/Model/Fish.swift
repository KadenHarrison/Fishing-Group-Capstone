//
//  Fish.swift
//  Fishing Game
//
//  Created by Jane Madsen on 1/29/25.
//

import Foundation
import UIKit

enum FishRarity: String, Codable {
    case normal, rare
}

enum FishType: String, Codable, CaseIterable {
    case salmon, trout, cod, tuna, perch, catfish, bass, loach, piranha, anglerfish, eel, bluegill, carp, koi, walleye, spacefish
    
    /// gets the fishes rarity based on a random int generator
    static func randomRarity() -> FishRarity {
        let r = Int.random(in: 1...100)
        
        if r < 85 {
            return .normal
        } else {
            return .rare
        }
    }
    
    //creates a random size for the fish
    func randomSize(rarity: FishRarity) -> Double {
        Double.random(in: rarity == .normal ? self.sizeRange.average : self.sizeRange.rare)
    }
    
    //base price for all the fish
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
    
    //size range for all the fish types
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


struct Fish: Codable, CustomStringConvertible {
    //data needed to create the fish
    var type: FishType
    var rarity: FishRarity
    var size: Double
    var price: Double {
        return type.basePrice * size * 0.1
    }
    
    //auto creates the description from other values
    var description: String {
        "\(rarity.rawValue.capitalized) \(type.rawValue.capitalized), size \(size)"
    }
    
    init(type: FishType, rarity: FishRarity, size: Double) {
        self.type = type
        self.rarity = rarity
        self.size = size
    }
    
    //generates the data from helper functions
    static func generateRandomFish(from types: [FishType]) -> Fish {
        let type = types.randomElement() ?? .salmon
        let rarity = FishType.randomRarity()
        let size = type.randomSize(rarity: rarity)
        
        return Fish(type: type, rarity: rarity, size: size)
    }
    
    var image: UIImage? {
        UIImage(named: self.type.rawValue)
    }
    
    static var fishAppearedImage: UIImage {
        UIImage(named: "fishAppeared")!
    }
}
