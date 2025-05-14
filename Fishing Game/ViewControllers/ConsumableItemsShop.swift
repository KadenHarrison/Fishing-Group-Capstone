//
//  ConsumableItemsShop.swift
//  Fishing Game
//
//  Created by Kaden Harrison on 5/13/25.
//
import SwiftUI

struct ConsumableItemsShop: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Text("Welcome to the Shop")
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
                        }
                    }
                }
        }
    }
}
