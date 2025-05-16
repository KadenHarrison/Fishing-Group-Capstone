//
//  DynamicTypeFontHelper.swift
//  Fishing Game
//
//  Created by Skyler Robbins on 5/15/25.
//

import Foundation
import UIKit

class DynamicTypeFontHelper {
    func applyDynamicFont(
        fontName: String,
        size: CGFloat,
        textStyle: UIFont.TextStyle = .body,
        to label: UILabel
    ) {
        if let customFont = UIFont(name: fontName, size: size) {
            label.font = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont)
            label.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback to system font with dynamic type
            label.font = UIFont.preferredFont(forTextStyle: textStyle)
            label.adjustsFontForContentSizeCategory = true
            print("⚠️ Font '\(fontName)' not found. Falling back to system font.")
        }
    }

}
