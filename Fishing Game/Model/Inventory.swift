//
//  Inventory.swift
//  Fishing Game
//
//  Created by Kevin Bjornberg on 5/9/25.
//

/*
This file handles all of the Single Use Items that the player can purchase in the shop at the end of each day.
The file also will handle any items fished up other than fish, such as trash and gold. Both of these items will be able to be sold in the shop
*/

import Foundation

class Item {
    var gold: Int
    var coffee: Int
    var Lures: Int
    var newspaper: Int
    var boot: Int
    var tire: Int
    
    init(gold: Int, coffee: Int, Lures: Int, newspaper: Int, boot: Int, tire: Int) {
        self.gold = gold
        self.coffee = coffee
        self.Lures = Lures
        self.newspaper = newspaper
        self.boot = boot
        self.tire = tire
    }
}

