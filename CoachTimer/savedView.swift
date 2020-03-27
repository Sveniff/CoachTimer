//
//  SwiftUIView.swift
//  CoachTimer
//
//  Created by Sven Iffland on 23.03.20.
//  Copyright © 2020 Sven Iffland. All rights reserved.
//

import SwiftUI

struct SavedView: View {
    @EnvironmentObject var saved: SaveHandler
    var body: some View {
        NavigationView{
            List{
                if saved.savedObject.count > 0 {
                    ForEach(Range(0...saved.savedObject.endIndex-1), id:\.self){ swimmer in
                        NavigationLink(destination: savedDetail(saved: self.saved.savedObject[swimmer])) {
                            Text(self.saved.savedObject[swimmer].name)
                        }
                    }.onDelete(perform: deleteSwimmer)
                }
            }.navigationBarTitle("Saved Swimmers").listStyle(GroupedListStyle())
        }
    }
    func deleteSwimmer(at offsets: IndexSet){
        saved.savedObject.remove(atOffsets: offsets)
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView().environmentObject(SaveHandler())
    }
}
