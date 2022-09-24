//
//  CityModel.swift
//  IslandModel2
//
//  Created by Jacky Jack on 18/09/2022.
//

import Foundation





class CityBase: CityBaseDelegate, NegotiationBuyerProtocol {
    
    var storage:Double = 0;
    var storageMax: Double = 100;
    var sellPrice:Double = 0;
    var buyPrice:Double = 0;
    var cash:Double = 0;
    
    init() {
        reset()
    }
    
    func reset() {
        storage = 4;
        storageMax = 100;
        sellPrice = 2.0;
        buyPrice = 1.0;
        cash = 100.0;
    }
    
    func requestSellAmount(_ sellAmount: Double) -> Double {
        print("Not implemented")
        abort()
        return 0.0
    }
    
    func requestSellPrice(_ sellPrice: Double) -> Double {
        print("Not implemented")
        abort()
        return 0.0
    }
    //TODO use request part to check if everything is ok, implement also in extensions
    func sell(_ sellAmount: Double, _ sellPrice: Double) -> Bool {
        self.storage -= sellAmount
        self.cash += sellAmount*sellPrice
        print("City sold \(sellAmount) for \(sellPrice) per piece")
        return true
    }
    
    func requestBuyPrice(_ requestPrice: Double) -> Double {
        print("Not implemented")
        abort()
        return 0.0
    }
    
    func requestBuyAmount(_ requestAmount: Double) -> Double {
        print("Not implemented")
        abort()
        return 0.0
    }
    
    func buy(_ buyAmount:Double, _ buyPrice:Double) -> Bool {
        //assume this all is correct, after negotiation protocol is done
        self.storage += buyAmount
        self.cash    -= buyPrice*buyAmount
        print("City bought \(buyAmount) for \(buyPrice) per piece")
        return true
    }
    
    func simulationStep() {
        print("City run simulation step")
    }
}

protocol CityBaseDelegate: AnyObject {
    func getStorage()->String;
    func getSellPrice()->String;
    func getBuyPrice()->String;
    func getCash()->String;
}

extension CityBase {
    func getStorage() -> String {
        print("Get self.storage \(self.storage)")
        return String(self.storage)
    }
    
    func getSellPrice() -> String {
        return String(self.sellPrice)
    }
    
    func getBuyPrice() -> String {
        return String(self.buyPrice)
    }
    
    func getCash() -> String {
        return String(self.cash)
    }

}

