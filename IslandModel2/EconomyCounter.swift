//
//  Stats.swift
//  IslandModel2
//
//  Created by Jacky Jack on 25/09/2022.
//

import Foundation



class StatAverageValue {
    private var vals: [Double]
    private var valCounter: Int
    private var valAll: Double
    private var days: Int
    
    
    init(days: Int) {
        self.days = days
        self.vals = Array<Double>(repeating: 0.0, count: self.days)
        self.valCounter = 0
        self.valAll = 0
    }
    
    func reset() {
        self.days = 0
        self.vals = []
        self.valCounter = 0
        self.valAll = 0
    }
    
    func addVal(_ val: Double) {
        self.vals[self.valCounter] = val
        self.valCounter += 1
        if self.valCounter >= self.days {
            self.valCounter = 0
        }
        self.valAll += val
    }
    
    func getAverage(days: Int) -> Double {
        var sum=0.0
        //get average value
        for v in self.vals {
            sum += v
        }
        return sum/Double(days)
    }
    
    func get1dAVG() -> Double {
        getAverage(days: 1)
    }
    
    func get5dAVG() -> Double {
        getAverage(days: 5)
    }
    
    func get30dAVG() -> Double {
        return getAverage(days: 30)
    }
    
    func getAll() -> Double {
        return self.valAll
    }
    
}


class EconomyCounter {
    
    var exportCounter:StatAverageValue
    var importCounter: StatAverageValue
    var mineCounter: StatAverageValue
    var storageCounter: StatAverageValue
    var sellCounter: StatAverageValue
    var buyCounter: StatAverageValue
    
    var tableContent: [StatCounter]
    
    init() {
        exportCounter = StatAverageValue(days: 30)
        importCounter = StatAverageValue(days: 30)
        mineCounter = StatAverageValue(days: 30)
        storageCounter = StatAverageValue(days: 30)
        sellCounter = StatAverageValue(days: 30)
        buyCounter = StatAverageValue(days: 30)
        tableContent = Array(repeating: StatCounter(), count: 6)
    }
    
    func reset() {
        exportCounter.reset()
        importCounter.reset()
        mineCounter.reset()
        storageCounter.reset()
        sellCounter.reset()
        buyCounter.reset()
    }
    
    func updateTable() {
        //let formater = NumberFormatter()
        //formater.
        //export
        tableContent[0].statName = "Export"
        
        //import
        tableContent[1].statName = "Import"
        
        //update mine
        tableContent[2].statName = "Mine"
        tableContent[2].stat1d = String(format:"%.1f",mineCounter.get1dAVG())
        tableContent[2].stat5d = String(format:"%.1f",mineCounter.get5dAVG())
        tableContent[2].stat30d = String(format:"%.1f",mineCounter.get30dAVG())
        tableContent[2].statAll = String(format:"%.1f",mineCounter.getAll())
        
        //storage
        tableContent[3].statName = "Storage"
        tableContent[3].stat1d = String(format:"%.1f",storageCounter.get1dAVG())
        tableContent[3].stat5d = String(format:"%.1f",storageCounter.get5dAVG())
        tableContent[3].stat30d = String(format:"%.1f",storageCounter.get30dAVG())
        tableContent[3].statAll = String(format:"%.1f",storageCounter.getAll())
        
        //sell
        tableContent[4].statName = "Sell"
        
        
        //buy
        tableContent[5].statName = "Buy"
    }
    
    func mineAddVal(_ val: Double) {
        mineCounter.addVal(val)
    }
    
    
    func mineGetAVG() -> [Double] {
        var r = Array<Double>(repeating: 0.0, count: 4)
        r[0] = mineCounter.get1dAVG()
        r[1] = mineCounter.get5dAVG()
        r[2] = mineCounter.get30dAVG()
        r[3] = mineCounter.getAll()
        return r
    }
}
