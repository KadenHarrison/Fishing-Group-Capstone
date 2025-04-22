//
//  Location.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/2/25.
//

import Foundation

class Location: Codable {
    var name: String
    var thumbnailName: String
    var backgroundName: String {
        thumbnailName + "bg" // Name of the background image
    }
    var requiredLicense: FishingLicense
    var requiredBoat: Boat
/// Types of fish that can be caught at this location
    var availableFish: [FishType] 
/// Types of fish the user has caught
    var caughtFish: [FishType] = [] 
    
    init(name: String, thumbnailName: String, requiredLicense: FishingLicense, requiredBoat: Boat, availableFish: [FishType]) {
        self.name = name
        self.thumbnailName = thumbnailName
        self.requiredLicense = requiredLicense
        self.requiredBoat = requiredBoat
        self.availableFish = availableFish
    }
}

//extension Location {
//    static var list: [Location] = [mountain, valley, river, shore, deepSea]
//
//    static func load() {
//        do {
//            if let locationList = try SaveDataManager.shared.loadLocations() {
//                Location.list = locationList
//            }
//        } catch {
//            NSLog("Error loading location list: \(error)")
//        }
//    }
//    
//    static func save() {
//        do {
//            try SaveDataManager.shared.save(locations: Location.list)
//        } catch {
//            NSLog("Error saving location list: \(error)")
//        }
//    }
//}

// Refactoring locations load and save functions.

// MARK: Locations

enum AllLocations: CaseIterable {
    case mountain
    case river
    case valley
    case shore
    case deepSea

    var location: Location {
        switch self {
        case .mountain:
            return Location(
                name: "Mountain",
                thumbnailName: "mountainlake",
                requiredLicense: .mountain,
                requiredBoat: .canoe,
                availableFish: [.trout, .salmon, .perch, .walleye]
            )
        case .river:
            return Location(
                name: "River",
                thumbnailName: "mountainlake",
                requiredLicense: .river,
                requiredBoat: .rowboat,
                availableFish: [.catfish, .loach, .eel, .piranha, .carp, .trout, .bass]
            )
        case .valley:
            return Location(
                name: "Valley",
                thumbnailName: "mountainlake",
                requiredLicense: .valley,
                requiredBoat: .canoe,
                availableFish: [.bluegill, .bass, .carp, .perch, .koi, .walleye, .catfish, .loach]
            )
        case .shore:
            return Location(
                name: "Shore",
                thumbnailName: "mountainlake",
                requiredLicense: .shore,
                requiredBoat: .rowboat,
                availableFish: [.cod, .eel, .tuna]
            )
        case .deepSea:
            return Location(
                name: "Deep Sea",
                thumbnailName: "deepsea",
                requiredLicense: .deepSea,
                requiredBoat: .submarine,
                availableFish: [.anglerfish, .tuna, .cod, .eel, .spacefish]
            )
        }
    }
}
