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
