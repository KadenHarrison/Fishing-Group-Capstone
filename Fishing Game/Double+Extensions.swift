//
//  Double+Extensions.swift
//  Fishing Game
//
//  Created by Jane Madsen on 2/14/25.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
