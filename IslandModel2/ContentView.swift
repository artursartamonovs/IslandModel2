//
//  ContentView.swift
//  IslandModel2
//
//  Created by Jacky Jack on 16/09/2022.
//

import SwiftUI

struct ContentView: View {
    @State var MenuItem:Int = 0
    @StateObject var mh: SimulationController = SimulationController()
    
    var body: some View {
        return Group {
            switch (MenuItem) {
            case 0:
                MainView(MenuItem: $MenuItem)
            case 1:
                GameView(MenuItem: $MenuItem)
            default:
                GameView(MenuItem: $MenuItem)
            }
        }.environmentObject(mh)
            //.frame(width: 400.0, height: 300.0, alignment: .topLeading)
    }
}

struct MainView:View {
    @Binding var MenuItem:Int
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Island economy simulator v0.1")
                    .padding()
            }
            Spacer()
            HStack {
                Button(action: {
                    MenuItem = 1
                }) {
                    Text("Start game")
                }.padding()
            }
            Spacer()
        }
    }
}

struct GameView: View {
    @Binding var MenuItem:Int
    @EnvironmentObject var mh:SimulationController

    var body: some View {
        TabView {
            StartContentView()
            .tabItem{
                    Text("Simulation")
            }
            CityContentView()
                .tabItem {
                    Text("City")
                }
            MineContentView()
                .tabItem {
                    Text("Mine")
                }
            PortContentView()
                .tabItem {
                    Text("Port")
                }
            StatContentView()
                .tabItem {
                    Text("Total")
                }
        }.environmentObject(mh)
    }
}

struct StartContentView: View {
    @EnvironmentObject var mh:SimulationController
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {}) {
                Text("Start")
            }.padding()
            Spacer()
            Button(action: {
                mh.runCbStep()
                mh.runPbStep()
                mh.runMbStep()
                mh.ec.mineAddVal(mh.mb.getStorageChange())
                mh.updateStat()
                print("All all cities in single step")
            }) {
                Text("Step")
            }.padding()
            Spacer()
            Button(action: {}) {
                Text("Reset")
            }.padding()
                .frame(minWidth: 0.0,maxWidth: .infinity)
            Spacer()
        }.padding()
    }
}

//CITY
struct CityContentView: View {
    @EnvironmentObject var mh:SimulationController
    
    @State private var autotradeOn = false
    @State private var autostoreOn = false
    @State private var storeAmount = ""
    
    var body: some View {
        
        VStack {
            
            Text("Boring city its all about transporting good from one part to other")
            HStack {
                Text("Buy Rate:")
                Text(mh.cityBuyPriceLabel)
            }
            HStack {
                Text("Sell Rate:")
                Text(mh.citySellPriceLabel)
            }
            HStack {
                Text("Storage:")
                Text("10")
            }.storageValue(text:mh.cityStorageLabel)
            HStack {
                Text("Cash:")
                Text(mh.cityCashLabel)
            }
            HStack {
                Button(action:{
                    mh.cb.simulationStep()
                    mh.runMbStep()
                    print("City: Press Step button")
                }) {
                    Text("Step")
                }
            }
            HStack {
                Toggle("Autotrade", isOn: $autotradeOn)
                Button(action:{
                    let buyer = mh.cb
                    let seller = mh.mb
                    let ng = Negotiation();
                    ng.offerBuyAmount(buyer.negotiationBuyAmount())
                    ng.offferBuyPrice(buyer.negotiationBuyPrice())
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
                    mh.runMbStep()
                    
                }) {
                    Text("Trade")
                }
                
                
            }
            
            HStack {
                Toggle("Store", isOn: $autostoreOn)
                TextField("Target", text: $storeAmount)
            }
        }
        
    }
}

struct StorageValue: ViewModifier {
    var text: String
    func body(content: Content) -> some View {
        HStack {
            Text("Storage:")
            Text(text)
        }
    }
}

//MINE
struct MineContentView: View {
    @EnvironmentObject var mh:SimulationController
    
    @State var labelStorage = "100"
    @State var labelProduction = "100"
    @State var labelPrice:String = "100"
    
    @State private var autotradeOn = false
    @State private var autostoreOn = false
    @State private var storeAmount = ""
    
    var body: some View {
        VStack {
            Text("Miners city, all about mining here, greem and misty place.")
            HStack {
                Text("Storage:")
                Text("2")
            }.storageValue(text:mh.mineStorageLabel)
            HStack {
                Text("Production:")
                Text(String(mh.mineProdcutionLabel))
            }
            HStack {
                Text("Price:")
                Text(String(mh.minePriceLabel))
            }
            HStack {
                Text("Cash:")
                Text(String(mh.mineCashLabel))
            }
            
            HStack {
                Button(action:{
                    mh.runMbStep()
                    mh.ec.mineAddVal(mh.mb.getStorageChange())
                    mh.updateStat()
                    print("Mine: Press Step button")
                }) {
                    Text("Step")
                }
            }
            HStack {
                Toggle("Store", isOn: $autostoreOn)
                TextField("Target", text: $storeAmount)
            }
        }
    }
}

extension View {
    func storageValue(text: String) -> some View {
        modifier(StorageValue(text: text))
    }
}

struct PortContentView:View {
    @EnvironmentObject var mh:SimulationController
    
    @State private var autotradeOn = false
    @State private var autostoreOn = false
    @State private var storeAmount = ""
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Cash")
                Text(mh.portCashLabel)
            }
            HStack {
                Text("Storage")
                Text(mh.portStorageLabel)
            }
            HStack {
                Text("Sell price")
                Text(mh.portSellPriceLabel)
            }
            HStack {
                Text("Buy price")
                Text(mh.portBuyPriceLabel)
            }
            HStack {
                Text("Demand")
                Text(mh.portDemandLabel)
            }
            HStack {
                Button(action:{
                    mh.runPbStep()
                    print("Mine: Press Step button")
                }) {
                    Text("Step")
                }
            }
            HStack {
                Button(action:{
                    //trade between port and city
                    let buyer = mh.pb
                    let seller = mh.cb
                    let ng = Negotiation();
                    print("Port trade")
                    print("\(buyer.negotiationBuyAmount()) \(buyer.negotiationBuyPrice())")
                    print("\(seller.negotiationSellAmount()) \(seller.negotiationSellPrice())")
                    ng.offerBuyAmount(buyer.negotiationBuyAmount())
                    ng.offferBuyPrice(buyer.negotiationBuyPrice())
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
                    
                    
                    
                    print("Port: Press Trade button")
                    mh.runPbStep()
                    
                    
                }) {
                    Text("Trade")
                }
                Button(action: {
                    print("Export goods")
                    //trade between port and outerland
                    print("Outerland trade")
                    let export_buyer = mh.ex
                    let port_seller = mh.pb
                    let ex_pb_negotiation = Negotiation()
                    print("\(export_buyer.negotiationBuyAmount()) \(export_buyer.negotiationBuyPrice())")
                    print("\(port_seller.negotiationSellAmount()) \(port_seller.negotiationSellPrice())")
                    ex_pb_negotiation.offerBuyAmount(export_buyer.negotiationBuyAmount())
                    ex_pb_negotiation.offferBuyPrice(export_buyer.negotiationBuyPrice())
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
                    mh.runExStep()
                }) {
                    Text("Export")
                }
            }
            
            HStack {
                Toggle("Store", isOn: $autostoreOn)
                TextField("Target", text: $storeAmount)
            }
        }
    }
}





struct StatContentView: View {
    @EnvironmentObject var mh:SimulationController
    var body: some View {
        VStack {
            HStack {
                Text("Table of statistics")
            }
            VStack {
            if (mh.updateEconomy>0) {
                Table(mh.ec.tableContent) {
                    TableColumn("Stat", value:\.statName)
                    TableColumn("1d",   value:\.stat1d)
                    TableColumn("5d",   value:\.stat5d)
                    TableColumn("30d",  value:\.stat30d)
                    TableColumn("Stat", value:\.statAll)
                }.lineLimit(6)
                
            }
            }
            HStack {
                Text("All data")
            }
        }
    }
}
/*
struct ContentView_Previews: PreviewProvider {
    @Binding var switchSucess: Bool
    static var previews: some View {
        ContentView()
    }
}
*/
