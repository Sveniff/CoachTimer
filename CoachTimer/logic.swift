//
//  File.swift
//  CoachTimer
//
//  Created by Sven Iffland on 12.03.20.
//  Copyright © 2020 Sven Iffland. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class Swimmer: ObservableObject, Identifiable {
    var timer: Timer
    var time: Int
    @Published var finished: Bool
    @Published var capColor: Color = .red
    @Published var name: String
    @Published var distance: Int
    @Published var lapLength: Int
    @Published var stringDist: String = ""
    @Published var stringLapLength: String = ""
    @Published var stringTime: String
    @Published var laps: [Int]
    @Published var lap: Int
    @Published var lapDiff: [Int]
    @Published var saved: Bool
    init(name:String, distance: Int, lapLength: Int) {
        self.saved = false
        self.finished = false
        self.time = 0
        self.lap = 0
        self.name = name
        self.distance = distance
        self.lapLength = lapLength
        self.laps = []
        self.timer = Timer()
        self.stringTime = Swimmer.convertCountToTimeString(counter: 0)
        self.lapDiff = []
        self.stringLapLength = String(lapLength)
        self.stringDist = String(distance)
    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        self.objectWillChange.send()
    }
    func stopTimer(){
        timer.invalidate()
        self.finished = true
    }
    func lapDone(){
        laps.append(time)
        lapDiff.append(time - (lap > 0 ? laps[lap-1] : 0))
        lap += 1
        if lap >= distance/lapLength{
            self.stopTimer()
        }
    }
    func reset(){
        self.saved = false
        self.finished = false
        self.time = 0
        self.lap = 0
        self.laps.removeAll()
        self.lapDiff.removeAll()
        self.timer = Timer()
        self.stringTime = Swimmer.convertCountToTimeString(counter: 0)
    }
    func changeDist() {
        self.distance = (Int(stringDist) != 0 ? Int(stringDist) : self.distance) ?? self.distance
        print(self.stringDist)
        print(self.distance)
        print("\n")
    }
    func changeLaplength() {
        self.lapLength = (Int(stringLapLength) != 0 ? Int(stringLapLength) : self.lapLength) ?? self.lapLength
        print(self.stringLapLength)
        print(self.lapLength)
        print("\n")
    }
    @objc func updateTimer(){
        time += 1
        self.stringTime = Swimmer.convertCountToTimeString(counter: self.time)
    }
}
extension Swimmer {
    static func convertCountToTimeString(counter: Int) -> String {
        let millseconds = counter % 100
        let seconds = counter / 100
        let minutes = seconds / 60
        
        var millsecondsString = "\(millseconds)"
        var secondsString = "\(seconds%60)"
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
}


class SwimHandler: ObservableObject {
    @Published var swimmers = [Swimmer]()
    init() {
        self.swimmers = [Swimmer(name: "", distance: 400, lapLength: 50),Swimmer(name: "", distance: 400, lapLength: 50),Swimmer(name: "", distance: 400, lapLength: 50)]
    }
}


class SavedSwimmer: ObservableObject, Identifiable {
    @Published var name: String
    @Published var runs: [run] = []
    init(swimmer: Swimmer){
        self.name = swimmer.name
        runs.append(run(swimmer: swimmer))
    }
}


public class SaveHandler: NSObject, ObservableObject {
    @Published var savedObject: [SavedSwimmer] = []
    @Published var names: [String] = []
}


class run: ObservableObject {
    @Published var name: String
    @Published var time: Int
    @Published var laps: [Int] = []
    @Published var lapDiff: [Int] = []
    @Published var date: String
    @Published var distance: Int
    @Published var lapLength: Int
    init(swimmer: Swimmer) {
        self.name = swimmer.name
        self.time = swimmer.time
        self.date = ""
        self.distance = swimmer.distance
        self.lapLength = swimmer.lapLength
        self.lapDiff.append(contentsOf: swimmer.lapDiff)
        self.laps.append(contentsOf: swimmer.laps)
    }
}
