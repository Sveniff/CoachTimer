//
//  ContentView.swift
//  CoachTimer
//
//  Created by Sven Iffland on 12.03.20.
//  Copyright © 2020 Sven Iffland. All rights reserved.
//

import SwiftUI
struct ContentView: View {
    @EnvironmentObject private var swimmers: SwimHandler
    var body: some View {
        TabView{
            NavigationView {
                List{
                    HStack{
                        Button(action: {for swimmer in self.swimmers.swimmers {
                            if swimmer.finished != true{
                                swimmer.startTimer()
                            }
                        }}){
                            Text("Start all")
                        }.frame(width:100 ,height:30).overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1))
                        Spacer()
                        Button(action: {
                            self.swimmers.swimmers.append(Swimmer(name: "", distance: 400, lapLength: 50))
                        }){
                            Text("+")
                        }.frame(width: 20, height: 20).overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1)).buttonStyle(BorderlessButtonStyle())

                    }
                    if self.swimmers.swimmers.count != 0{
                        ForEach(Range(0...swimmers.swimmers.endIndex-1), id: \.self) { swimmer in
                            NavigationLink(destination: SwimmerDetail(swimmer: self.swimmers.swimmers[swimmer])){
                                    SwimmerView(swimmer: self.swimmers.swimmers[swimmer])
                            }
                        }.onDelete(perform: deleteSwimmer).shadow(radius: 10)
                    }
                }.navigationBarTitle("Swimmers").listStyle(GroupedListStyle())
            }.tabItem{
                Text("Timer")
            }.tag(0)
            SavedView().tabItem{
                Text("Archive")
            }.tag(1)
        }
    }
    func deleteSwimmer(at offsets: IndexSet){
        swimmers.swimmers.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SwimHandler())
    }
}
