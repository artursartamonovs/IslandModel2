//
//  ExportModel.swift
//  IslandModel2
//
//  Created by Jacky Jack on 30/09/2022.
//

import Foundation

enum DemandStrategy {
    case flat
    case seasonal //spring,summer,autumn,winter
    case fluctuate //changes randomly
}

class ExportModel: NegotiationBuyerProtocol, NegotiationSellerProtocol {
    var demandAmount: Double = 10
    var demandPrice: Double = 5
    var timeline: Double = 0
    var demandPattern: DemandStrategy = .flat
    
    init() {
        reset()
    }
    
    func reset() {
        demandAmount = 10.0
        demandPrice = 5
        timeline = 0
        demandPattern = .flat
    }
    
    func negotiationBuyAmount() -> Double {
        return self.demandAmount
    }
    func negotiationBuyPrice() -> Double {
        return self.demandPrice
    }
    func negotiationSellPrice() -> Double {
        print("Not implemented")
        abort()
        return 0.0
    }
    func negotiationSellAmount() -> Double {
        print("Not implemented")
        abort()
        return 0.0
    }
    
    func sell(_ requestAmount: Double, _ requestPrice: Double) -> Double {
        let totalPrice:Double = requestAmount*requestPrice;
        print("Mine -> Agreed sell price \(requestPrice) amount \(requestAmount)");
        //self.cash += totalPrice;
        self.demandAmount -= requestAmount;
        
        print("Mine sold \(requestAmount) for \(requestPrice) per piece")
        
        return totalPrice
    }
    
    func buy(_ buyAmount:Double, _ buyPrice:Double) -> Double {
        var amount = buyAmount
        //total requested amount of money neede
        var totalPrice = buyPrice*buyAmount
        //if totalPrice too big to buy
        /*if (totalPrice>self.cash) {
            //just buy how much can buy
            let pieces = ceil(self.cash/buyPrice)
            let possiblePrice = pieces*buyPrice
            amount = pieces
            totalPrice = possiblePrice
        }*/
        self.demandAmount -= amount
        //self.cash -= totalPrice
        
        //return price of transaction
        return totalPrice
        
    }
    
    func simulationStep() {
        //move over timeline
        timeline += 1
    }
    
    func getDemand() -> String {
        return String(self.demandAmount)
    }
}
