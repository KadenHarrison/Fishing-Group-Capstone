//
//  SaveDataManager.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/26/25.
//

import Foundation

final class SaveDataManager {
    static let shared = SaveDataManager()
    
    private init() {}
    
    func save<T: Encodable>(_ object: T, forKey key: String) throws {
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(object)
        UserDefaults.standard.set(jsonData, forKey: key)
    }
    
    func load<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let jsonData = UserDefaults.standard.data(forKey: key) else { return nil }
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(T.self, from: jsonData)
    }
}

class TackleboxService {
    static let shared = TackleboxService(repository: FileTackleboxRepository())

    private let repository: TackleboxRepository
    private(set) var tacklebox: Tacklebox

    init(repository: TackleboxRepository) {
        self.repository = repository
        self.tacklebox = Tacklebox()
        load()
    }

    func load() {
        if let loaded = try? repository.loadTacklebox() {
            tacklebox = loaded
        }
    }

    func save() {
        do {
            try repository.saveTacklebox(tacklebox)
        } catch {
            print("Failed to save tacklebox: \(error)")
        }
    }
    
    func reset() {
        tacklebox = Tacklebox()
        save()
    }
}

class LocationService {
    static let shared = LocationService(repository: FileLocationRepository())
    
    private let repository: LocationRepository
    private(set) var locations: [Location]
    private(set) var caughtFishRecords: [String: LocationCaughtFish] = [:]
    
    init(repository: LocationRepository) {
        self.repository = repository
        self.locations = []
        load()
    }
    
    func save() {
        do {
            try repository.saveLocations(locations)
            try repository.saveCaughtFishRecords(Array(caughtFishRecords.values))
        } catch {
            print("Failed to save locationsL \(error)")
        }
    }
    
    func load() {
        do {
            locations = try repository.loadLocations()
            let records = try repository.loadCaughtFishRecords()
            caughtFishRecords = Dictionary(uniqueKeysWithValues: records.map { ($0.location.name, $0) })
        } catch {
            print("Failed to load locations: \(error)")
            locations = []
            caughtFishRecords = [:]
        }
    }
    
    func resetToDefaults() {
        locations = AllLocations.allCases.map { $0.location }
        caughtFishRecords.removeAll()
        save()
    }
    
    func updateCaughtFish(for location: Location, caughtFish: [Fish]) {
        let locationName = location.name
        let fishTypes = caughtFish.map { $0.type }
        
        // Get or create the player's record for this location
        if caughtFishRecords[locationName] == nil {
            // First time catching fish at this location
            caughtFishRecords[locationName] = LocationCaughtFish(location: location, caughtFish: Set(fishTypes))
        } else {
            // Already has a record - update it with new fish
            caughtFishRecords[locationName]?.caughtFish.formUnion(fishTypes)
        }
        
        save()
    }
}
