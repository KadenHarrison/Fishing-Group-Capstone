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
    
    func addCash(_ amount: Int) {
        tacklebox.cash += amount
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
