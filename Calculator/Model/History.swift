//
//  History.swift
//  Calculator
//
//  Created by znexie on 12.03.25.
//

import Foundation
import Firebase

struct History: Identifiable {
    
    var id: String
    var operation: String
    var result: String
    var timestamp: Date?
}
