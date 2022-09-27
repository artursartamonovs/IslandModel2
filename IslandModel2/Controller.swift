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
    var cb:CityBase
    var pb:PortBase
    @Published var mineStorageLabel:String
    @Published var mineProdcutionLabel:String
    @Published var minePriceLabel:String
    @Published var mineCashLabel:String
    @Published var cityStorageLabel:String
    @Published var citySellPriceLabel:String
    @Published var cityBuyPriceLabel:String
    @Published var cityCashLabel:String
    @Published var portStorageLabel:String
    @Published var portSellPriceLabel:String
    @Published var portBuyPriceLabel:String
    @Published var portCashLabel:String
    @Published var portDemandLabel:String
    
    init() {
        self.mb = MineBase()
        self.cb = CityBase()
        self.pb = PortBase()
        mineCashLabel = ""
        minePriceLabel = ""
        mineStorageLabel = ""
        mineProdcutionLabel = ""
        cityCashLabel = ""
        citySellPriceLabel = ""
        cityBuyPriceLabel = ""
        cityStorageLabel = ""
        portCashLabel = ""
        portStorageLabel = ""
        portBuyPriceLabel = ""
        portSellPriceLabel = ""
        portDemandLabel = ""
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
        portCashLabel = self.pb.getCash()
        portStorageLabel = self.pb.getStorage()
        portBuyPriceLabel = self.pb.getBuyPrice()
        portSellPriceLabel = self.pb.getSellPrice()
        portDemandLabel = self.pb.getDemand()
    }
    
    func runMbStep() {
        mb.simulationStep()
        update()
    }
    
    func runCbStep() {
        cb.simulationStep()
        update()
    }
    
    func runPbStep() {
        pb.simulationStep()
        update()
    }
    
    func reset() {
        mb.reset()
        cb.reset()
    }
    
    func runAllStep() {
        mb.simulationStep()
        cb.simulationStep()
        pb.simulationStep()
        update()
    }
    
}
