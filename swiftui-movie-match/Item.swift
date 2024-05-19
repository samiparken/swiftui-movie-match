//
//  Item.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-05-19.
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
