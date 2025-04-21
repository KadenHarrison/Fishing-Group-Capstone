//
//  SaveDataManager.swift
//  Fishing Game
//
//  Created by Jane Madsen on 3/26/25.
//

import Foundation

class SaveDataManager {
    static let shared = SaveDataManager()
    
    /// Saves the user's tacklebox
    func save(tacklebox: Tacklebox) throws {
        let jsonEncoder = JSONEncoder()
        
        let json = try jsonEncoder.encode(tacklebox)
        
        UserDefaults.standard.set(json, forKey: "tacklebox")
    }
    
    /// loads the user's tacklebox
    func loadTacklebox() throws -> Tacklebox? {
        guard let jsonData = UserDefaults.standard.data(forKey: "tacklebox") else { return nil }
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(Tacklebox.self, from: jsonData)
    }
    
    /// Saves the locations that the user has unlocked
    func save(locations: [Location]) throws {
        let jsonEncoder = JSONEncoder()
        
        let json = try jsonEncoder.encode(locations)
        
        UserDefaults.standard.set(json, forKey: "locations")
    }
    
    /// Loads the locations that the user has unlocked
    func loadLocations() throws -> [Location]? {
        guard let jsonData = UserDefaults.standard.data(forKey: "locations") else { return nil }
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode([Location].self, from: jsonData)
    }
}
