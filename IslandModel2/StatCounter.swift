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
        stat1d = "N/A"
        stat5d = "N/A"
        stat30d = "N/A"
        statAll = "N/A"
    }
}
