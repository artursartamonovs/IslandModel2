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
    var ec:EconomyCounter
    var ex:ExportModel
    @Published var updateEconomy: Int {
        willSet {
            objectWillChange.send()
        }
    }
    //mine
    @Published var mineStorageLabel:String
    @Published var mineProdcutionLabel:String
    @Published var minePriceLabel:String
    @Published var mineCashLabel:String
    @Published var mineAutoStoreOn:Bool
    @Published var mineAutoStoreVal:Int
    
    //city
    @Published var cityStorageLabel:String
    @Published var citySellPriceLabel:String
    @Published var cityBuyPriceLabel:String
    @Published var cityCashLabel:String
    
    //port
    @Published var portStorageLabel:String
    @Published var portSellPriceLabel:String
    @Published var portBuyPriceLabel:String
    @Published var portCashLabel:String
    @Published var portDemandLabel:String
    
    init() {
        self.mb = MineBase()
        self.cb = CityBase()
        self.pb = PortBase()
        self.ec = EconomyCounter()
        self.ex = ExportModel()
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
        updateEconomy = 1
        mineAutoStoreOn = false
        mineAutoStoreVal = 0
        update()
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
        //portDemandLabel = self.pb.getDemand()
        portDemandLabel = self.ex.getDemand()
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
    
    func runExStep() {
        ex.simulationStep()
        update()
    }
    
    func reset() {
        mb.reset()
        cb.reset()
        pb.reset()
        ex.reset()
    }
    
    func runAllStep() {
        mb.simulationStep()
        cb.simulationStep()
        pb.simulationStep()
        ex.simulationStep()
        update()
    }
    
    func tradeMineCity() {
        let buyer = self.cb
        let seller = self.mb
        let ng = Negotiation();
        ng.offerBuyAmount(buyer.negotiationBuyAmount())
        ng.offerBuyPrice(buyer.negotiationBuyPrice())
        ng.offerSellPrice(seller.negotiationSellPrice())
        ng.offerSellAmount(seller.negotiationSellAmount())
        ng.simpleNegotiation()
        let sellerResult = ng.sellerNegotiation()
        let buyerResult = ng.buyerNegoatiation()
        if sellerResult.succeffull && buyerResult.succeffull {
            print("Transaction can be succesfull")
            let _ = buyer.buy(buyerResult.amount, buyerResult.price)
            let _ = seller.sell(sellerResult.amount, sellerResult.price)
        }
        print("City: Press Trade button")
    }
    
    func tradeCityPort() {
        let buyer = self.pb
        let seller = self.cb
        let ng = Negotiation();
        print("Port trade")
        print("\(buyer.negotiationBuyAmount()) \(buyer.negotiationBuyPrice())")
        print("\(seller.negotiationSellAmount()) \(seller.negotiationSellPrice())")
        ng.offerBuyAmount(buyer.negotiationBuyAmount())
        ng.offerBuyPrice(buyer.negotiationBuyPrice())
        ng.offerSellPrice(seller.negotiationSellPrice())
        ng.offerSellAmount(seller.negotiationSellAmount())
        ng.simpleNegotiation()
        let sellerResult = ng.sellerNegotiation()
        let buyerResult = ng.buyerNegoatiation()
        if sellerResult.succeffull && buyerResult.succeffull {
            print("Transaction can be succesfull")
            let _ = buyer.buy(buyerResult.amount, buyerResult.price)
            let _ = seller.sell(sellerResult.amount, sellerResult.price)
        }
    }
    
    func tradePortExport() {
        let export_buyer = self.ex
        let port_seller = self.pb
        let ex_pb_negotiation = Negotiation()
        print("\(export_buyer.negotiationBuyAmount()) \(export_buyer.negotiationBuyPrice())")
        print("\(port_seller.negotiationSellAmount()) \(port_seller.negotiationSellPrice())")
        ex_pb_negotiation.offerBuyAmount(export_buyer.negotiationBuyAmount())
        ex_pb_negotiation.offerBuyPrice(export_buyer.negotiationBuyPrice())
        ex_pb_negotiation.offerSellPrice(port_seller.negotiationSellPrice())
        ex_pb_negotiation.offerSellAmount(port_seller.negotiationSellAmount())
        ex_pb_negotiation.simpleNegotiation()
        let ex_pb_sellerResult = ex_pb_negotiation.sellerNegotiation()
        let ex_pb_buyerResult = ex_pb_negotiation.buyerNegoatiation()
        if ex_pb_sellerResult.succeffull && ex_pb_buyerResult.succeffull {
            print("Transaction can be succesfull")
            let _ = export_buyer.buy(ex_pb_buyerResult.amount, ex_pb_buyerResult.price)
            let _ = port_seller.sell(ex_pb_sellerResult.amount, ex_pb_sellerResult.price)
        }
        
        
    }
    
    func updateStat() {
        self.updateEconomy += 1
        //get all storage values
        let storage = self.mb.storage + self.cb.storage + self.pb.storage
        self.ec.storageCounter.addVal(storage)
        self.ec.updateTable()
    }
    
}
