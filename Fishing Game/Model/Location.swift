//
//  Location.swift
//  Fishing Game
//
//  Created by Jane Madsen on 4/2/25.
//

import Foundation

protocol LocationRepository {
    func saveLocations(_ locations: [Location]) throws
    func loadLocations() throws -> [Location]
    
    func saveCaughtFishRecords(_ records: [LocationCaughtFish]) throws
    func loadCaughtFishRecords() throws -> [LocationCaughtFish]
}

class FileLocationRepository: LocationRepository {
    func saveLocations(_ locations: [Location]) throws {
        print("Saving Locations")
        try SaveDataManager.shared.save(locations, forKey: "locations")
    }
    
    func loadLocations() throws -> [Location] {
        return try SaveDataManager.shared.load([Location].self, forKey: "locations") ?? []
    }
    
    func saveCaughtFishRecords(_ records: [LocationCaughtFish]) throws {
        try SaveDataManager.shared.save(records, forKey: "caughtFishRecords")
    }
    
    func loadCaughtFishRecords() throws -> [LocationCaughtFish] {
        return try SaveDataManager.shared.load([LocationCaughtFish].self, forKey: "caughtFishRecords") ?? []
    }
}

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
    var locationCaughtFish: LocationCaughtFish?
        
    init(name: String, thumbnailName: String, requiredLicense: FishingLicense, requiredBoat: Boat, availableFish: [FishType]) {
        self.name = name
        self.thumbnailName = thumbnailName
        self.requiredLicense = requiredLicense
        self.requiredBoat = requiredBoat
        self.availableFish = availableFish
    }
}

// MARK: AllLocations

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
                name: "Mountain".localized(),
                thumbnailName: "mountainlake",
                requiredLicense: .mountain,
                requiredBoat: .canoe,
                availableFish: [.trout, .salmon, .perch, .walleye]
            )
        case .river:
            return Location(
                name: "River".localized(),
                thumbnailName: "mountainlake",
                requiredLicense: .river,
                requiredBoat: .rowboat,
                availableFish: [.catfish, .loach, .eel, .piranha, .carp, .trout, .bass]
            )
        case .valley:
            return Location(
                name: "Valley".localized(),
                thumbnailName: "mountainlake",
                requiredLicense: .valley,
                requiredBoat: .canoe,
                availableFish: [.bluegill, .bass, .carp, .perch, .koi, .walleye, .catfish, .loach]
            )
        case .shore:
            return Location(
                name: "Shore".localized(),
                thumbnailName: "mountainlake",
                requiredLicense: .shore,
                requiredBoat: .rowboat,
                availableFish: [.cod, .eel, .tuna]
            )
        case .deepSea:
            return Location(
                name: "Deep Sea".localized(),
                thumbnailName: "deepsea",
                requiredLicense: .deepSea,
                requiredBoat: .submarine,
                availableFish: [.anglerfish, .tuna, .cod, .eel, .spacefish]
            )
        }
    }
}

// MARK: LocationCaughtFish

class LocationCaughtFish: Codable {
    var caughtFish: Set<FishType>
    
    init(caughtFish: Set<FishType>) {
        self.caughtFish = caughtFish
    }
}
