//
//  RiddleLocation.swift
//  DukeScavenger
//
//  Created by Robert on 4/7/21.
//

import Foundation

class RiddleLocation {
    var latitude: Double
    var longitude: Double
    var locName: String
    var solved: Bool
    
    init(latitude: Double, longitude: Double, locName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.locName = locName
        self.solved = false
    }
    
    func solve() {
        self.solved = true
    }
}
