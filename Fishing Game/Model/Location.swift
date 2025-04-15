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
        thumbnailName + "bg"
    }
    var requiredLicense: FishingLicense
    var requiredBoat: Boat
    var availableFish: [FishType]
    var caughtFish: [FishType] = []
    
    init(name: String, thumbnailName: String, requiredLicense: FishingLicense, requiredBoat: Boat, availableFish: [FishType]) {
        self.name = name
        self.thumbnailName = thumbnailName
        self.requiredLicense = requiredLicense
        self.requiredBoat = requiredBoat
        self.availableFish = availableFish
    }
}

extension Location {
    static var list: [Location] = [mountain, valley, river, shore, deepSea]

    static func load() {
        do {
            if let locationList = try SaveDataManager.shared.loadLocations() {
                Location.list = locationList
            }
        } catch {
            NSLog("Error loading location list: \(error)")
        }
    }
    
    static func save() {
        do {
            try SaveDataManager.shared.save(locations: Location.list)
        } catch {
            NSLog("Error saving location list: \(error)")
        }
    }
}

fileprivate let mountain = Location(
    name: "Mountain",
    thumbnailName: "mountainlake",
    requiredLicense: .mountain,
    requiredBoat: .canoe,
    availableFish: [.trout, .salmon, .perch, .walleye]
)

private let river = Location(
    name: "River",
    thumbnailName: "mountainlake",
    requiredLicense: .river,
    requiredBoat: .rowboat,
    availableFish: [.catfish, .loach, .eel, .piranha, .carp, .trout, .bass]
)

private let valley = Location(
    name: "Valley",
    thumbnailName: "mountainlake",
    requiredLicense: .valley,
    requiredBoat: .canoe,
    availableFish: [.bluegill, .bass, .carp, .perch, .koi, .walleye, .catfish, .loach]
)

private let shore = Location(
    name: "Shore",
    thumbnailName: "mountainlake",
    requiredLicense: .shore,
    requiredBoat: .rowboat,
    availableFish: [.cod, .eel, .tuna]
)

private let deepSea = Location(
    name: "Deep Sea",
    thumbnailName: "deepsea",
    requiredLicense: .deepSea,
    requiredBoat: .submarine,
    availableFish: [.anglerfish, .tuna, .cod, .eel, .spacefish]
)
