//
//  MineModel.swift
//  IslandModel2
//
//  Created by Jacky Jack on 24/09/2022.
//

import Foundation

class MineBase: MineBaseDelegate, NegotiationSellerProtocol {
    var storage:Double = 0;
    var storageMax: Double = 100;
    var productionRate:Double = 0;
    var productionRateMax:Double = 0;
    var productionRateMin:Double = 0;
    var productionCost:Double = 0;
    var price:Double = 0;
    var cash:Double = 0;
    
    init() {
        reset()
    }
    
    func reset() {
        storage = 4;
        storageMax = 100;
        productionRate = 2;
        productionRateMin = 2;
        productionRateMax = 10;
        productionCost = 1;
        price = 1.0;
        cash = 100.0;
    }
    
    func setProductionRate(_ pr:Double) -> Double {
        if pr < self.productionRateMin {
            self.productionRate = self.productionRateMin;
            
        } else if pr > self.productionRateMax {
            self.productionRate = self.productionRateMax;
            
        } else {
            self.productionRate = pr;
        }
        return self.productionRate
    }
    
    func requestSell(_ requestAmount: Double) -> Double {
        if (requestAmount > Double(self.storage)) {
            return Double(self.storage);
        }
        return requestAmount;
    }
    
    func requestSellPrice(_ requestPrice: Double) -> Double {
        if (requestPrice < Double(self.price)) {
            return Double(self.price);
        }
        return requestPrice;
    }
    
    func sell(_ requestAmount: Double, _ requestPrice: Double) -> Double {
        let totalPrice:Double = requestAmount*requestPrice;
        print("Mine -> Agreed sell price \(requestPrice) amount \(requestAmount)");
        self.cash += totalPrice;
        self.storage -= requestAmount;
        
        print("Mine sold \(requestAmount) for \(requestPrice) per piece")
        
        return totalPrice
    }
    
    func simulationStep() {
        var addToStorage:Double=0
        //let productionRate = self.productionRate;
        //get the production cost, if no money still minimal production happens
        let prodCost = self.productionRate * self.productionCost
        if prodCost < self.cash {
            self.cash -= prodCost;
            addToStorage = self.productionRate
        } else {
            addToStorage = self.productionRateMin;
        }
        
        //add final storage value
        self.storage += addToStorage
        if self.storage > self.storageMax {
            let vasted = self.storage - self.storageMax
            print("Mine vasted \(vasted) resources")
            self.storage = self.storageMax
        }
        if self.storage < 0 {
            self.storage = 0
            print("Mine ERROR negative storage value")
        }
        
        print("Mine run simulation step")
    }
}

protocol MineBaseDelegate: AnyObject {
    func getStorage()->String;
    func getPrice()->String;
    func getCash()->String;
    func getProductionRage()->String;
    
}

extension MineBase {
    func getStorage() -> String {
        print("Get self.storage \(self.storage)")
        return String(self.storage)
    }
    
    func getPrice() -> String {
        return String(self.price)
    }
    
    func getCash() -> String {
        return String(self.cash)
    }

    func getProductionRage() -> String {
        return String(self.productionRate)
    }
}
