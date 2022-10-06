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
                //run all trades
                mh.tradeMineCity()
                mh.tradeCityPort()
                mh.tradePortExport()
                //run all steps
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
    @State private var autostoreOn = false {
        didSet {
            //mh.mb.setStorageAutoStore(autostoreOn, Double(storeAmount))
            print("setStorageAutoStore \(autostoreOn) \(storeAmount)")
        }
    }
    @State private var storeAmount = 0 {
        didSet {
            //mh.mb.setStorageAutoStore(autostoreOn, Double(storeAmount))
            print("setStorageAutoStore \(autostoreOn) \(storeAmount)")
        }
    }
    
    var body: some View {
        
        VStack {
            Text("Boring city its all about transporting good from one part to other")
            Divider()
            HStack {
                Text("Buy Rate:").storageStyleLeading()
                Text(mh.cityBuyPriceLabel).storageStyleTrailing()
            }
            HStack {
                Text("Sell Rate:").storageStyleLeading()
                Text(mh.citySellPriceLabel).storageStyleTrailing()
            }
            HStack {
                //Text("Storage:")//.frame(maxWidth: .infinity, alignment: .leading)
                //Text("10")//.frame(maxWidth: .infinity, alignment: .trailing)
            }.storageValue(text:mh.cityStorageLabel)
            HStack {
                Text("Cash:").storageStyleLeading()
                Text(mh.cityCashLabel).storageStyleTrailing()
            }
            Divider()
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
                    mh.tradeMineCity()
                    mh.runMbStep()
                    
                }) {
                    Text("Trade")
                }
                
                
            }
            
            HStack {
                Toggle("Store", isOn: $autostoreOn)
                TextField("Target", value: $storeAmount, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
        }
        
    }
}

struct StorageValue: ViewModifier {
    var text: String
    func body(content: Content) -> some View {
        HStack {
            Text("Storage:").frame(maxWidth: .infinity, alignment: .leading)
            Text(text).frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

extension View {
    func storageValue(text: String) -> some View {
        modifier(StorageValue(text: text))
    }
}
struct StorageStyleLeading: ViewModifier {
    func body(content: Content) -> some View {
            content
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StorageStyleTrailing: ViewModifier {
    func body(content: Content) -> some View {
            content
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

extension View {
    func storageStyleTrailing() -> some View {
        modifier(StorageStyleTrailing())
    }
}

extension View {
    func storageStyleLeading() -> some View {
        modifier(StorageStyleLeading())
    }
}

//MINE
struct MineContentView: View {
    @EnvironmentObject var mh:SimulationController
    
    @State var labelStorage = "100"
    @State var labelProduction = "100"
    @State var labelPrice:String = "100"
    
    @State  var autotradeOn = false
    @State  var autostoreOn = false 
    @State private var storeAmount = 0
    
    var body: some View {
        VStack {
            Text("Miners city, all about mining here, greem and misty place.")
            Divider()
            HStack {
                //Text("Storage:").frame(maxWidth: .infinity, alignment: .leading)
                //Text("2").frame(maxWidth: .infinity, alignment: .trailing)
            }.storageValue(text:mh.mineStorageLabel)
            HStack {
                Text("Production:").storageStyleLeading()
                Text(String(mh.mineProdcutionLabel)).storageStyleTrailing()
            }
            HStack {
                Text("Price:").storageStyleLeading()
                Text(String(mh.minePriceLabel)).storageStyleTrailing()
            }
            HStack {
                Text("Cash:").storageStyleLeading()
                Text(String(mh.mineCashLabel)).storageStyleTrailing()
            }
            Divider()
            
            HStack {
                Button(action:{
                    mh.mb.setStorageAutoStore(autostoreOn, Double(storeAmount))
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
                    .padding()
                    .onChange(of: autostoreOn){
                        newValue in mh.mb.setStorageAutoStore(autostoreOn, Double(storeAmount))
                    }
                TextField("Target", value: $storeAmount, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: storeAmount){
                        newValue in mh.mb.setStorageAutoStore(autostoreOn, Double(storeAmount))
                    }
            }
        }
    }
}



struct PortContentView:View {
    @EnvironmentObject var mh:SimulationController
    
    @State private var autotradeOn = false
    @State private var autostoreOn = false
    @State private var storeAmount = 0
    
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                Text("Cash").storageStyleLeading()
                Text(mh.portCashLabel).storageStyleTrailing()
            }
            HStack {
                Text("Storage").storageStyleLeading()
                Text(mh.portStorageLabel).storageStyleTrailing()
            }
            HStack {
                Text("Sell price").storageStyleLeading()
                Text(mh.portSellPriceLabel).storageStyleTrailing()
            }
            HStack {
                Text("Buy price").storageStyleLeading()
                Text(mh.portBuyPriceLabel).storageStyleTrailing()
            }
            HStack {
                Text("Demand").storageStyleLeading()
                Text(mh.portDemandLabel).storageStyleTrailing()
            }
            Divider()
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
                    mh.tradeCityPort()
                    print("Port: Press Trade button")
                    mh.runPbStep()
                }) {
                    Text("Trade")
                }
                Button(action: {
                    print("Export goods")
                    //trade between port and outerland
                    print("Outerland trade")
                    mh.tradePortExport()
                    mh.runExStep()
                }) {
                    Text("Export")
                }
            }
            
            HStack {
                Toggle("Store", isOn: $autostoreOn)
                TextField("Target", value: $storeAmount, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding()
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
