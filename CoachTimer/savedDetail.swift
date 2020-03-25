//
//  savedDetail.swift
//  CoachTimer
//
//  Created by Sven Iffland on 23.03.20.
//  Copyright © 2020 Sven Iffland. All rights reserved.
//

import SwiftUI

struct savedDetail: View {
    @ObservedObject var saved: SavedSwimmer
    var body: some View {
        VStack{
            List{
                if saved.runs.count > 0 {
                    ForEach(Range(0...saved.runs.endIndex-1)) { run in
                        NavigationLink(destination: RunDetail(swimmer: self.saved.runs[run])) {
                                                Text("\(self.saved.runs[run].date)  \(convertCountToTimeString(counter: self.saved.runs[run].laps[self.saved.runs[run].laps.endIndex-1]))")
                        }
                    }.onDelete(perform: deleteTime)
                }
            }.navigationBarTitle("\(self.saved.name)").listStyle(GroupedListStyle())
        }
    }
    func deleteTime(at offsets: IndexSet){
        saved.runs.remove(atOffsets: offsets)
    }
}

struct savedDetail_Previews: PreviewProvider {
    static var previews: some View {
        savedDetail(saved: SavedSwimmer(swimmer: Swimmer(name: "Sven", distance: 400, lapLength: 50)))
    }
}


