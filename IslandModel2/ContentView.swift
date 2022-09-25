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
    }
}

struct MainView:View {
    @Binding var MenuItem:Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Island economy simulator v0.1").padding()
                Button(action: {
                    MenuItem = 1
                }) {
                    Text("Start game")
                }.padding()
            }
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
            Text("Body")
                .tabItem {
                    Text("Stats")
                }
        }.environmentObject(mh)
    }
}

struct StartContentView: View {
    @EnvironmentObject var mh:SimulationController
    
    var body: some View {
        VStack {
            Button(action: {}) {
                Text("Start")
            }.padding()
            Button(action: {}) {
                Text("Step")
            }.padding()
            Button(action: {}) {
                Text("Reset")
            }.padding()
        }.padding()
    }
}

//CITY
struct CityContentView: View {
    @EnvironmentObject var mh:SimulationController
    
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
                    print("Mine: Press Step button")
                }) {
                    Text("Step")
                }
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
    var body: some View {
        VStack {
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
                    let buyer = mh.pb
                    let seller = mh.cb
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
                    mh.runCbStep()
                    
                }) {
                    Text("Trade")
                }
            }
        }
    }
}
/*
struct ContentView_Previews: PreviewProvider {
    @Binding var switchSucess: Bool
    static var previews: some View {
        //ContentView()
    }
}*/
