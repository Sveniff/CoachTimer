//
//  SwimmerDetail.swift
//  CoachTimer
//
//  Created by Sven Iffland on 19.03.20.
//  Copyright © 2020 Sven Iffland. All rights reserved.
//

import SwiftUI

struct SwimmerDetail: View {
    @State var showAlert = false
    @ObservedObject var swimmer: Swimmer
    @EnvironmentObject var saved: SaveHandler
    var body: some View {
        VStack{
            Text(self.swimmer.name).padding().font(.custom("", size: 80)).multilineTextAlignment(.center).fixedSize().frame(width: UIScreen.main.bounds.width, height: 100)
            HStack {
                Text(String(self.swimmer.stringTime)).font(.custom("", size: 40)).foregroundColor(self.swimmer.lap * self.swimmer.lapLength >= self.swimmer.distance ? Color.green : Color.red)
                Text("\(self.swimmer.lap * self.swimmer.lapLength) m").frame(width: UIScreen.main.bounds.width/8, height: 60)
            }
            Button(action: {self.swimmer.time > 0 ? self.swimmer.lap*self.swimmer.lapLength >= self.swimmer.distance ? self.showAlert = true : self.swimmer.lapDone() : self.swimmer.startTimer()}) {
                Text(self.swimmer.time > 0 ? self.swimmer.lap*self.swimmer.lapLength >= self.swimmer.distance ? "reset" : "lap" : "start")
            }.alert(isPresented:$showAlert) {
                Alert(title: Text("Are you sure you want to reset this?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Reset")) {
                    self.swimmer.reset()
                }, secondaryButton: .cancel())
            }.frame(width: UIScreen.main.bounds.width/4, height: 40).buttonStyle(BorderlessButtonStyle()).multilineTextAlignment(.center)
            HStack{
                if self.swimmer.saved || !self.swimmer.finished{
                    Spacer()
                }
                TextField("Distance", text: $swimmer.stringDist, onCommit: {self.swimmer.changeDist()}).frame(width: UIScreen.main.bounds.width/6, height: 40).multilineTextAlignment(.trailing)
                Text("m").frame(width: UIScreen.main.bounds.width/16, height: 40)
                TextField("Lap length", text: $swimmer.stringLapLength, onCommit: {self.swimmer.changeLaplength()}).frame(width: UIScreen.main.bounds.width/6, height: 40).multilineTextAlignment(.trailing)
                Text("m").frame(width: UIScreen.main.bounds.width/16, height: 40)
                Spacer()
                Spacer()
                Button(action: {
                    self.swimmer.changeDist()
                    self.swimmer.changeLaplength()
                }){
                    Text("Update")
                }.frame(width: UIScreen.main.bounds.width/5, height: 40).multilineTextAlignment(.center)
                Spacer()
                if self.swimmer.finished && !self.swimmer.saved{
                    Button(action: {
                        let nameIndex = self.saved.names.firstIndex(of: self.swimmer.name)
                        if nameIndex == nil{
                            self.saved.savedObject.append(SavedSwimmer(swimmer: self.swimmer))
                            self.saved.names.append(self.swimmer.name)
                            self.saved.savedObject[self.saved.savedObject.endIndex-1].name = self.swimmer.name != "" ? self.swimmer.name : "Unnamed"
                        }
                        else{
                            self.saved.savedObject[self.saved.names.firstIndex(of: self.swimmer.name) ?? -1].runs.append(run(swimmer: self.swimmer))
                        }
                        self.swimmer.saved = true
                    }){
                    Text("Save")
                    }.frame(width: UIScreen.main.bounds.width/6, height: 40).multilineTextAlignment(.center)
                    Spacer()
                }

            }.overlay(RoundedRectangle(cornerRadius: 2).stroke())
            HStack{
                Spacer()
                Text("Interval").font(.custom("", size: 25)).padding()
                Spacer()
                Divider()
                Spacer()
                Text("lap only").font(.custom("", size: 25)).padding()
                Spacer()
                Divider()
                Spacer()
                Text("total Time").font(.custom("", size: 25)).padding()
            }.frame(width: UIScreen.main.bounds.width, height: 50)
            List{
                if self.swimmer.laps.count > 0 {
                    ForEach(Range(0...swimmer.laps.endIndex-1), id:\.self) { lap in
                        HStack{
                            Text("\(lap*self.swimmer.lapLength)m - \((lap + 1)*self.swimmer.lapLength)m").fixedSize().frame(width: UIScreen.main.bounds.width/4, height: 20)
                            Spacer()
                            Divider()
                            Spacer()
                            Text("\(convertCountToTimeString(counter: self.swimmer.lapDiff[lap]))").fixedSize().frame(width: UIScreen.main.bounds.width/4, height: 20)
                            Spacer()
                            Divider()
                            Spacer()
                            Text(String(convertCountToTimeString(counter: self.swimmer.laps[lap]))).fixedSize().frame(width: UIScreen.main.bounds.width/4, height: 20)
                            Spacer()
                        }
                    }
                }
            }.frame(width: UIScreen.main.bounds.width).listStyle(GroupedListStyle())
            Spacer()
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct SwimmerDetail_Previews: PreviewProvider {
    static var previews: some View {
        SwimmerDetail(swimmer: Swimmer(name: "", distance: 400, lapLength: 50)).environmentObject(SaveHandler())
    }
}

func convertCountToTimeString(counter: Int) -> String {
    let millseconds = counter % 100
    var seconds = counter / 100
    let minutes = seconds / 60
    seconds %= 60
    
    var millsecondsString = "\(millseconds)"
    var secondsString = "\(seconds)"
    var minutesString = "\(minutes)"
    
    if millseconds < 10 {
        millsecondsString = "0" + millsecondsString
    }
    
    if seconds < 10 {
        secondsString = "0" + secondsString
    }
    
    if minutes < 10 {
        minutesString = "0" + minutesString
    }
    
    return "\(minutesString):\(secondsString),\(millsecondsString)"
}
