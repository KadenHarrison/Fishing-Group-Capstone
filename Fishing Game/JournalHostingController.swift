//
//  JournalHostingController.swift
//  Fishing Game
//
//  Created by Skyler Robbins on 5/13/25.
//

import SwiftUI

class JournalHostingController: UIHostingController<JournalView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: JournalView())
    }
}
