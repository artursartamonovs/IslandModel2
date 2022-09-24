//
//  Controller.swift
//  IslandModel2
//
//  Created by Jacky Jack on 24/09/2022.
//

import Foundation
import Combine

class SimulationController: ObservableObject {
    let didChange = PassthroughSubject<Bool,Never>()
    let didChangeStr = PassthroughSubject<String,Never>()
    var mb:MineBase
    var cb: CityBase
    @Published var mineStorageLabel:String
    @Published var mineProdcutionLabel:String
    @Published var minePriceLabel:String
    @Published var mineCashLabel:String
    @Published var cityStorageLabel:String
    @Published var citySellPriceLabel:String
    @Published var cityBuyPriceLabel:String
    @Published var cityCashLabel:String
    
    init() {
        self.mb = MineBase()
        self.cb = CityBase()
        mineCashLabel = ""
        minePriceLabel = ""
        mineStorageLabel = ""
        mineProdcutionLabel = ""
        cityCashLabel = ""
        citySellPriceLabel = ""
        cityBuyPriceLabel = ""
        cityStorageLabel = ""
    }
    
    func update() {
        mineCashLabel = self.mb.getCash()
        minePriceLabel = self.mb.getPrice()
        mineStorageLabel = self.mb.getStorage()
        mineProdcutionLabel =  self.mb.getProductionRage()
        cityCashLabel = self.cb.getCash()
        citySellPriceLabel = self.cb.getSellPrice()
        cityBuyPriceLabel = self.cb.getBuyPrice()
        cityStorageLabel = self.cb.getStorage()
    }
    
    func runMbStep() {
        mb.simulationStep()
        update()
    }
    
    func runCbStep() {
        cb.simulationStep()
        update()
    }
    
    func reset() {
        mb.reset()
        cb.reset()
    }
    
    func runAllStep() {
        mb.simulationStep()
        cb.simulationStep()
        update()
    }
    
}
