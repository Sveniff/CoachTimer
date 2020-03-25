//
//  RundDetail.swift
//  CoachTimer
//
//  Created by Sven Iffland on 23.03.20.
//  Copyright © 2020 Sven Iffland. All rights reserved.
//

import SwiftUI

struct RunDetail: View {
    @ObservedObject var swimmer: run
    var body: some View {
        VStack{
            Spacer()
            .frame(width: UIScreen.main.bounds.width, height: 100)
            Text(self.swimmer.name).padding().font(.custom("", size: 80)).multilineTextAlignment(.center).fixedSize().frame(width: UIScreen.main.bounds.width, height: 100)
            HStack {
                Text(String(convertCountToTimeString(counter: self.swimmer.time))).font(.custom("", size: 40)).foregroundColor(Color.green)
            }
            HStack{
                Spacer()
                Text("\(swimmer.distance)m").frame(width: UIScreen.main.bounds.width/5, height: 40).multilineTextAlignment(.trailing)
                Spacer()
                Text("\(swimmer.lapLength)m").frame(width: UIScreen.main.bounds.width/5, height: 40).multilineTextAlignment(.trailing)
                Spacer()

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
                    ForEach(Range(0...swimmer.laps.endIndex-1)) { lap in
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
            }.id(UUID()).frame(width: UIScreen.main.bounds.width).listStyle(GroupedListStyle())
            Spacer()
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct RunDetail_Previews: PreviewProvider {
    static var previews: some View {
        RunDetail(swimmer: run(swimmer: Swimmer(name: "Test", distance: 400, lapLength: 50)))
    }
}
