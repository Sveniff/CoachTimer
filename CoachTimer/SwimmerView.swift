//
//  SwiftUIView.swift
//  CoachTimer
//
//  Created by Sven Iffland on 12.03.20.
//  Copyright © 2020 Sven Iffland. All rights reserved.
//
import SwiftUI
import Foundation

struct SwimmerView: View {
    @ObservedObject var swimmer: Swimmer
    @State var newName = ""
    @State var showAlert = false
    var body: some View {
        HStack{
            Spacer()
            if !self.swimmer.timer.isValid {
                TextField("Name", text: $swimmer.name).multilineTextAlignment(.leading).frame(width: 100, height: 60).font(.custom("", size: 30))
            }
            else{
                Text(self.swimmer.name)
                    .multilineTextAlignment(.leading)
                    .frame(width: 100, height: 60)
                    .font(.custom("", size: 30))
            }
            Divider()
            Button(action: {self.swimmer.time > 0 ? self.swimmer.lap*self.swimmer.lapLength >= self.swimmer.distance ? self.showAlert = true : self.swimmer.lapDone() : self.swimmer.startTimer()}) {
                Text(self.swimmer.time > 0 ? self.swimmer.lap*self.swimmer.lapLength >= self.swimmer.distance ? "reset" : "lap" : "start")                    .font(.custom("", size: 20))

            }
                .alert(isPresented:$showAlert) {
                    Alert(title: Text("Are you sure you want to reset this?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Reset")) {self.swimmer.reset()
                    }, secondaryButton: .cancel())
                }
                .buttonStyle(BorderlessButtonStyle())
                
                .frame(width: 50, height: 60)
            Spacer()
            Text(String(self.swimmer.stringTime))
                
                .frame(width: (70), height: 60)
            Spacer()
            Text("\(self.swimmer.lap * self.swimmer.lapLength) m")
                
                .frame(width: 30, height: 60)
            Spacer()
        }
        .frame(width: 350, height: 60.0)
//        .background(LinearGradient(gradient: Gradient(colors: [Color(.lightGray),Color(.lightGray).opacity(0.5)]), startPoint: .leading, endPoint: .trailing).opacity(0.2))

            .overlay(RoundedRectangle(cornerRadius: 6).stroke(self.swimmer.lap * self.swimmer.lapLength >= self.swimmer.distance ? Color.green : Color.red, lineWidth: 5))
            .padding(.vertical)
//            .shadow(radius: 10)

    }
}

struct SwimmerView_Previews: PreviewProvider {
    static var previews: some View {
        SwimmerView(swimmer: Swimmer(name: "", distance: 400, lapLength: 50))
    }
}
