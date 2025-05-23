//
//  ConsumableItemsShop.swift
//  Fishing Game
//
//  Created by Kaden Harrison on 5/13/25.
//
import SwiftUI

struct ShopTheme {
    static let background = Color(red: 0.0, green: 0.38, blue: 0.88)
    static let tile = Color(red: 0.52, green: 0.26, blue: 0.0)
    static let text = Color.white
    static let accent = Color.blue
}

struct ConsumableItemsShop: View {
    @Environment(\.dismiss) var dismiss

    @State var cash: Int = TackleboxService.shared.tacklebox.cash
    @State var cashSpent = 0
    @State var coffee: Bool = TackleboxService.shared.tacklebox.hasCoffee
    @State var reelSpeedUp: Bool = TackleboxService.shared.tacklebox.hasReelSpeedUp
    @State var rarityLure: Bool = TackleboxService.shared.tacklebox.hasRarityLure
    @State var largeLure: Bool = TackleboxService.shared.tacklebox.hasLargeLure
//
    @State var spaceBait: Int = TackleboxService.shared.tacklebox.spaceBait

    @State private var showConfirmation = false
    @State private var showInsufficientFunds = false

    var body: some View {
        NavigationView {
            ZStack {
                ShopTheme.background.ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 16, pinnedViews: []) {
                        Button(action: {
                            cash += 1000
                            TackleboxService.shared.tacklebox.cash = cash
                        }) {
                            Text("Add $1000")
                                .foregroundColor(ShopTheme.text)
                                .padding()
                                .background(ShopTheme.accent)
                                .cornerRadius(8)
                        }
                        Text("$\(cash)")
                        Text("UPGRADES")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ShopTheme.tile)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Coffee - $50")
                                        .font(.headline)
                                        .foregroundColor(ShopTheme.text)
                                    Text("Day last lasts longer")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                                Toggle("", isOn: $coffee)
                                    .disabled(TackleboxService.shared.tacklebox.hasCoffee)
                                    .onChange(of: coffee) { newValue in
                                        cashSpent += newValue ? 50 : -50
                                    }
                                    .labelsHidden()
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        .frame(height: 80)

                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ShopTheme.tile)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Reel Speed Up - $100")
                                        .font(.headline)
                                        .foregroundColor(ShopTheme.text)
                                    Text("Speeds up reeling")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                                Toggle("", isOn: $reelSpeedUp)
                                    .disabled(TackleboxService.shared.tacklebox.hasReelSpeedUp)
                                    .onChange(of: reelSpeedUp) { newValue in
                                        cashSpent += newValue ? 100 : -100
                                    }
                                    .labelsHidden()
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        .frame(height: 80)

                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ShopTheme.tile)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Rarity Lure - $200")
                                        .font(.headline)
                                        .foregroundColor(ShopTheme.text)
                                    Text("Increases rare fish chance")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                                Toggle("", isOn: $rarityLure)
                                    .disabled(TackleboxService.shared.tacklebox.hasRarityLure)
                                    .onChange(of: rarityLure) { newValue in
                                        cashSpent += newValue ? 100 : -100
                                    }
                                    .labelsHidden()
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        .frame(height: 80)

                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ShopTheme.tile)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Large Lure - $150")
                                        .font(.headline)
                                        .foregroundColor(ShopTheme.text)
                                    Text("Attracts bigger fish")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                                Toggle("", isOn: $largeLure)
                                    .disabled(TackleboxService.shared.tacklebox.hasLargeLure)
                                    .onChange(of: largeLure) { newValue in
                                        cashSpent += newValue ? 100 : -100
                                    }
                                    .labelsHidden()
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        .frame(height: 80)

                        Text("BAIT")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ShopTheme.tile)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Space Bait - $10")
                                        .font(.headline)
                                        .foregroundColor(ShopTheme.text)
                                    Spacer()
                                    Stepper("Quantity: \(spaceBait)", value: $spaceBait, in: TackleboxService.shared.tacklebox.spaceBait...99)
                                        .onChange(of: spaceBait) { newValue in
                                            cashSpent = (newValue - TackleboxService.shared.tacklebox.spaceBait) * 10
                                        }
                                        .foregroundColor(ShopTheme.text)
                                }
                                Text("For cosmic fish")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        .frame(height: 100)


                        Button("Checkout") {
                            showConfirmation = true
                        }
                        .alert("Confirm Purchase", isPresented: $showConfirmation) {
                            Button("Confirm") {
                                if cashSpent > TackleboxService.shared.tacklebox.cash {
                                    showInsufficientFunds = true
                                } else {
                                    TackleboxService.shared.tacklebox.cash -= cashSpent
                                    TackleboxService.shared.tacklebox.hasCoffee = coffee
                                    TackleboxService.shared.tacklebox.hasReelSpeedUp = reelSpeedUp
                                    TackleboxService.shared.tacklebox.spaceBait = spaceBait
                                    TackleboxService.shared.tacklebox.hasLargeLure = largeLure
                                    TackleboxService.shared.tacklebox.hasRarityLure = rarityLure
                                    cash = TackleboxService.shared.tacklebox.cash
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                        .alert("Not enough money", isPresented: $showInsufficientFunds) {
                            Button("OK", role: .cancel) {}
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(ShopTheme.text)
                        .padding()
                        .background(ShopTheme.tile)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(ShopTheme.text)
                    }
                }
            }
        }
    }
}
