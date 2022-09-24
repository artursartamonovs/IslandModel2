//
//  Negotiation.swift
//  IslandModel2
//
//  Created by Jacky Jack on 24/09/2022.
//

import Foundation

struct NegotiationResult {
    var amount:Double
    var price:Double
    var succeffull: Bool
}

protocol NegotiationBuyerProtocol {
    /*
    func offerSellAmount(_ amount: Double)
    func offerSellPrice(_ price: Double)
    func offerBuyAmount(_ amount: Double)
    func offferBuyPrice(_ price: Double)
    func simpleNegotiation()
    func sellerNegotiation() -> NegotiationResult
    func buyerNegoatiation() -> NegotiationResult
    */
    func getBuyAmount() -> Double
    func getBuyPrice() -> Double
}

extension MineBase {
    
    func getSellPrice() -> Double {
        return self.price
    }
    
    func getSellAmount() -> Double {
        return self.storage
    }
}

protocol NegotiationSellerProtocol {
    func getSellPrice() -> Double
    func getSellAmount() -> Double
}

extension CityBase {
    func getBuyAmount() -> Double {
        return self.storageMax - self.storage
    }
    
    func getBuyPrice() -> Double {
        return self.buyPrice
    }
}

class Negotiation {
    private var sellerAmount = 0.0
    private var sellerPrice  = 0.0
    private var buyerAmount  = 0.0
    private var buyerPrice   = 0.0
    private var buyerResult:NegotiationResult
    private var sellerResult:NegotiationResult
    
    private var buyer: NegotiationBuyerProtocol?
    private var seller: NegotiationSellerProtocol?
    
    init() {
        sellerAmount = 0.0
        sellerPrice = 0.0
        buyerAmount = 0.0
        sellerPrice = 0.0
        buyerResult = NegotiationResult(amount: 0.0, price: 0.0, succeffull: false)
        sellerResult = NegotiationResult(amount: 0.0, price: 0.0, succeffull: false)
    }
    
    func offerSellAmount(_ amount: Double) {
        sellerAmount = amount
    }
    func offerSellPrice(_ price: Double ) {
        sellerPrice = price
    }
    func offerBuyAmount(_ amount: Double) {
        buyerAmount = amount
    }
    func offferBuyPrice(_ price: Double) {
        buyerPrice = price
    }
    func simpleNegotiation() {
        //negotiate sell/buy amount
        var transactionAmount = 0.0
        if self.buyerAmount > self.sellerAmount {
            transactionAmount = self.sellerAmount
        } else {
            transactionAmount = self.buyerAmount
        }
        self.sellerResult.amount = transactionAmount
        self.buyerResult.amount = transactionAmount
        
        //negotiate price
        var agreeOnPrice = false
        //simple logic behind negotiation
        if (self.buyerPrice <= self.sellerPrice) {
            agreeOnPrice = true
            sellerResult.price = self.buyerPrice
            buyerResult.price = self.buyerPrice
        }
        
        if agreeOnPrice {
            sellerResult.succeffull = true
            buyerResult.succeffull = true
        } else {
            sellerResult.succeffull = false
            buyerResult.succeffull = false
        }
    }
    func sellerNegotiation() -> NegotiationResult {
        return sellerResult
    }
    func buyerNegoatiation() -> NegotiationResult {
        return buyerResult
    }
}
