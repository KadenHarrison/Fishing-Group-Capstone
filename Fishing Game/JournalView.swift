//
//  JournalView.swift
//  Fishing Game
//
//  Created by Skyler Robbins on 5/13/25.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var sortOrder: SortOrder = .type
    @State private var showSortPicker = false
    @State private var searchText: String = ""

    enum SortOrder: String, CaseIterable, Identifiable {
        case type, rarity, size, price

        var id: String { rawValue }

        var label: String {
            switch self {
            case .type: return "Type"
            case .rarity: return "Rarity"
            case .size: return "Size"
            case .price: return "Price"
            }
        }
    }

    private var groupedEntries: [FishType: [FishRarity: [JournalEntry]]] {
        Dictionary(grouping: JournalService.shared.journal.entries) { $0.fishType }
            .mapValues { Dictionary(grouping: $0, by: { $0.rarity }) }
    }

    private var summarizedEntries: [FishSummary] {
        groupedEntries.flatMap { (type, rarityDict) in
            rarityDict.map { (rarity, entries) in
                FishSummary(type: type, rarity: rarity, entries: entries)
            }
        }
        .filter { searchText.isEmpty || $0.type.rawValue.localizedCaseInsensitiveContains(searchText) }
        .sorted(by: { lhs, rhs in
            switch sortOrder {
            case .type: return lhs.type.rawValue < rhs.type.rawValue
            case .rarity: return lhs.rarity.rawValue < rhs.rarity.rawValue
            case .size: return (lhs.largest ?? 0) > (rhs.largest ?? 0)
            case .price: return lhs.averagePrice > rhs.averagePrice
            }
        })
    }

    var body: some View {
        NavigationView {
            List(summarizedEntries) { summary in
                NavigationLink(destination: FishDetailView(summary: summary)) {
                    HStack(spacing: 16) {
                        Image(uiImage: UIImage(named: summary.type.rawValue) ?? UIImage())
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(summary.borderColor, lineWidth: 3)
                            )

                        VStack(alignment: .leading) {
                            Text("\(summary.rarity.rawValue.capitalized) \(summary.type.rawValue.capitalized)")
                                .font(.headline)
                            Text("Caught: \(summary.count)")
                                .font(.subheadline)
                            HStack(spacing: 4) {
                                ForEach(summary.possibleLocations, id: \ .self) { locName in
                                    let caught = summary.locationsCaught.contains(locName)
                                    Image(systemName: caught ? "checkmark.seal.fill" : "xmark.seal")
                                        .foregroundColor(caught ? .green : .gray)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Fish Journal")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort by", selection: $sortOrder) {
                            ForEach(SortOrder.allCases) { order in
                                Text(order.label).tag(order)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
}

struct FishDetailView: View {
    var summary: FishSummary

    var body: some View {
        VStack(spacing: 20) {
            Image(uiImage: UIImage(named: summary.type.rawValue) ?? UIImage())
                .resizable()
                .frame(width: 100, height: 100)

            Text(summary.type.rawValue.capitalized)
                .font(.largeTitle)
            Text("Rarity: \(summary.rarity.rawValue.capitalized)")
            Text("Caught at: \(summary.locationsCaught.joined(separator: ", "))")
            Text("Caught: \(summary.count) times")
            Text("Size Range: \(summary.possibleSizeRange.lowerBound)-\(summary.possibleSizeRange.upperBound)")
            Text("Smallest: \(summary.smallest ?? 0, specifier: "%.2f")")
            Text("Largest: \(summary.largest ?? 0, specifier: "%.2f")")

            Spacer()
        }
        .padding()
        .navigationTitle(summary.type.rawValue.capitalized)
    }
}

struct FishSummary: Identifiable {
    let id = UUID()
    let type: FishType
    let rarity: FishRarity
    let entries: [JournalEntry]

    var count: Int { entries.count }
    var locationsCaught: Set<String> { Set(entries.map { $0.location.name }) }
    var smallest: Double? { entries.map { $0.size }.min() }
    var largest: Double? { entries.map { $0.size }.max() }
    var averagePrice: Double { entries.map { $0.fish.price }.reduce(0, +) / Double(entries.count) }
    var possibleSizeRange: ClosedRange<Double> { type.sizeRangeFor(rarity: rarity) }

    var possibleLocations: [String] {
        AllLocations.allCases.map { $0.location }.filter { $0.availableFish.contains(type) }.map { $0.name }
    }

    var borderColor: Color {
        rarity == .rare ? .yellow : .gray
    }
}
