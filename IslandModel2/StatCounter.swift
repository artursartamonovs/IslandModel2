//
//  StatCounter.swift
//  IslandModel2
//
//  Created by Jacky Jack on 28/09/2022.
//

import Foundation


struct StatCounter: Identifiable {
    var statName: String
    var stat1d: String
    var stat5d: String
    var stat30d: String
    var statAll: String
    let id = UUID()
    
    init() {
        statName = "NoStat"
        stat1d = "0.0"
        stat5d = "0.0"
        stat30d = "0.0"
        statAll = "0.0"
    }
}
