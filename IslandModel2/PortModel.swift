//
//  PortModel.swift
//  IslandModel2
//
//  Created by Jacky Jack on 25/09/2022.
//

import Foundation

import Combine

class PortBase: PortBaseDelegate, NegotiationBuyerProtocol, NegotiationSellerProtocol {
    var storage:Double = 0;
    var storageMax:Double = 100;
    var demand: Double = 10;
    var buyPrice: Double = 3
    var sellPrice: Double = 4;
    var cash: Double = 0;
    
    init () {
        reset()
    }
    
    func reset() {
        storage = 0.0
        demand = 0.0
        buyPrice = 3.0
        sellPrice = 4.0
        cash = 100
    }
    
    func requestBuyPrice(_ requestPrice: Double) -> Double {
        if (requestPrice > Double(self.buyPrice)) {
            return self.buyPrice
        }
        return requestPrice
    }
    
    //buy all possible
    func requestBuyAmount(_ requestAmount: Double) -> Double {
        //check maximum amount that can fit into storage
        if (requestAmount > (self.storageMax - self.storage)) {
            
            return self.storageMax - self.storage
        }
        return requestAmount
        
    }
    
    func buy(_ buyAmount:Double, _ buyPrice:Double) -> Double {
        var amount = buyAmount
        //total requested amount of money neede
        var totalPrice = buyPrice*buyAmount
        //if totalPrice too big to buy
        if (totalPrice>self.cash) {
            //just buy how much can buy
            let pieces = ceil(self.cash/buyPrice)
            let possiblePrice = pieces*buyPrice
            amount = pieces
            totalPrice = possiblePrice
        }
        self.storage += amount
        self.cash -= totalPrice
        
        //return price of transaction
        return totalPrice
        
    }
    
    func requestSellPrice(_ requestPrice: Double) -> Double {
        if (requestPrice < Double(self.sellPrice)) {
            return Double(self.sellPrice);
        }
        return requestPrice;
    }
    
    func requestSellAmount(_ requestAmount: Double) -> Double {
        if (requestAmount > Double(self.storage)) {
            return Double(self.storage);
        }
        return requestAmount;
    }
    
    func sell(_ requestAmount: Double, _ requestPrice: Double) -> Double {
        let totalPrice:Double = requestAmount*requestPrice;
        print("Port -> Agreed sell price \(requestPrice) amount \(requestAmount)");
        self.cash += totalPrice;
        self.storage -= requestAmount;
        
        print("Port sold \(requestAmount) for \(requestPrice) per piece")
        
        return totalPrice
    }
    
    func simulationStep() {
        print("Port run simulation step")
    }
}

protocol PortBaseDelegate: AnyObject {
    func getStorage()->String;
    func getBuyPrice()->String;
    func getSellPrice()->String;
    func getCash()->String;
    func getDemand()->String;
}

extension PortBase {
    func getStorage() -> String {
        return String(self.storage)
    }
    func getBuyPrice() -> String {
        return String(self.buyPrice)
    }
    func getSellPrice() -> String {
        return String(self.sellPrice)
    }
    func getCash() -> String {
        return String(self.cash)
    }
    func getDemand() -> String {
        return String(self.demand)
    }
}
