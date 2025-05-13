//
//  SaveDataManager.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/26/25.
//

import Foundation

// MARK: SaveDataManager

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

// MARK: TackleboxService

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
    
    func addCash(_ amount: Int) {
        tacklebox.cash += amount
        save()
    }
    
}

// MARK: LocationService

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
    
    func saveLocation() {
        do {
            try repository.saveLocations(locations)
            let fishRecords = Array(caughtFishRecords.values)
            try repository.saveCaughtFishRecords(fishRecords)
        } catch {
            print("Failed to save locationsL \(error)")
        }
    }
    
    func load() {
        do {
            locations = try repository.loadLocations()
//            let records = try repository.loadCaughtFishRecords()
            locations.forEach { location in
                if let locationCaughtFish = location.locationCaughtFish {
                    caughtFishRecords[location.name] = locationCaughtFish
                }
            }
        } catch {
            print("Failed to load locations: \(error)")
            locations = []
            caughtFishRecords = [:]
        }
    }
    
    func resetToDefaults() {
        locations = AllLocations.allCases.map { $0.location }
        caughtFishRecords.removeAll()
        saveLocation()
    }
    
    func updateCaughtFish(for location: Location, with newFish: [Fish]) {
            guard let index = locations.firstIndex(where: { $0.name == location.name }) else {
                print("Location not found.")
                return
            }
            if locations[index].locationCaughtFish == nil {
                let fishTypes = Set(newFish.map { $0.type })
                locations[index].locationCaughtFish = LocationCaughtFish(caughtFish: fishTypes)
            } else {
                let record = locations[index].locationCaughtFish!
                let newFishTypes = newFish.map { $0.type }.filter { !record.caughtFish.contains($0) }
                record.caughtFish.formUnion(newFishTypes)
            }
            
            saveLocation()
        }
}

// MARK: JournalService

final class JournalService {
    static let shared = JournalService(repository: FileJournalRepository())

    private let repository: JournalRepository
    private(set) var journal: Journal

    init(repository: JournalRepository) {
        self.repository = repository
        self.journal = Journal()
        load()
    }

    /// Load journal from saved storage
    func load() {
        if let loaded = try? repository.loadJournal() {
            journal = loaded
        }
    }

    /// Save journal to storage
    func save() {
        do {
            try repository.saveJournal(journal)
        } catch {
            print("Failed to save journal: \(error)")
        }
    }

    /// Clear and reset the journal
    func reset() {
        journal = Journal()
        save()
    }

    /// Add an individual fish catch to the journal
    func recordCatch(_ fish: Fish, at location: Location) {
        journal.recordCatch(fish: fish, at: location)
        print("Fish type: \(fish.type.rawValue) of rarity: \(fish.rarity.rawValue) caught at \(location.name) added to the Journal")
        save()
    }
}

