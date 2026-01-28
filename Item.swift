//
//  Item.swift
//  SmartRecipeManager
//
//  Created by RPS on 22/01/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
