//
//  DesignHelper.swift
//  Fishing Game
//
//  Created by Kevin Bjornberg on 5/6/25.
//

import Foundation
import UIKit

enum DesignHelper {
    static func applyCapsuleDesign(_ view: UIView) {
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
    }
    
    static func applyImageDesign(_ image: UIImageView) {
        image.layer.borderWidth = 2
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 0.4
        image.layer.shadowOffset = CGSize(width: 0, height: 2)
        image.layer.shadowRadius = 6
        image.layer.backgroundColor = UIColor.white.cgColor
    }
}
