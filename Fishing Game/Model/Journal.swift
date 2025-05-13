//
//  Journal.swift
//  Fishing Game
//
//  Created by Skyler Robbins on 5/13/25.
//

import Foundation

// The user's fishing journal. Keeps track of all the fish the user has caught for each fish type and rarity, where those fish have been caught, and the extreme sizes of the fish that have been caught.
class Journal: Codable {
    private(set) var entries: [JournalEntry] = []

    /// Record a single fish catch into the journal
    func recordCatch(fish: Fish, at location: Location) {
        let entry = JournalEntry(fish: fish, location: location)
        entries.append(entry)
    }

    /// All catches of a specific fish type and rarity
    func catches(for type: FishType, rarity: FishRarity) -> [JournalEntry] {
        entries.filter { $0.fishType == type && $0.rarity == rarity }
    }

    /// Count of how many times a fish of a given type and rarity has been caught
    func catchCount(for type: FishType, rarity: FishRarity) -> Int {
        catches(for: type, rarity: rarity).count
    }

    /// All unique locations a fish of a given type and rarity has been caught at
    func locations(for type: FishType, rarity: FishRarity) -> Set<String> {
        Set(catches(for: type, rarity: rarity).map { $0.location.name })
    }

    /// Smallest and largest sizes caught of a given fish type and rarity
    func sizeExtremes(for type: FishType, rarity: FishRarity) -> (smallest: Double?, largest: Double?) {
        let sizes = catches(for: type, rarity: rarity).map { $0.size }
        return (sizes.min(), sizes.max())
    }
}

// MARK: JournalEntry

/// Represents a single fish caught by the user
struct JournalEntry: Codable {
    let fish: Fish
    let location: Location

    var size: Double { fish.size }
    var fishType: FishType { fish.type }
    var rarity: FishRarity { fish.rarity }

    var possibleSizeRange: ClosedRange<Double> {
        fishType.sizeRangeFor(rarity: rarity)
    }
}

// MARK: JournalRepository

protocol JournalRepository {
    func loadJournal() throws -> Journal
    func saveJournal(_ journal: Journal) throws
}

// MARK: FileJournalRepository

final class FileJournalRepository: JournalRepository {
    private let saveKey = "journalData"

    func loadJournal() throws -> Journal {
        return try SaveDataManager.shared.load(Journal.self, forKey: saveKey) ?? Journal()
    }

    func saveJournal(_ journal: Journal) throws {
        try SaveDataManager.shared.save(journal, forKey: saveKey)
    }
}
