//
//  Item.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 1/10/26.
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
