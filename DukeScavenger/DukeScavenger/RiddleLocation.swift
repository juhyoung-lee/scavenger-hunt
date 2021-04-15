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
    var spriteName: String
    
    init(latitude: Double, longitude: Double, locName: String, spriteName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.locName = locName
        self.solved = false
        self.spriteName = spriteName
    }
    
    func solve() {
        self.solved = true
    }
}
