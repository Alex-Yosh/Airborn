//
//  DataView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct DataView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ZStack{
            Constants.Colour.SecondaryLightGray.ignoresSafeArea()
            ScrollView(showsIndicators: false){
                if let selected = dataManager.selectedDataType{
                    DataDetailView()
                        .navigationTitle(selected.rawValue) // Sets the title in the top bar
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Back") {
                                    dataManager.selectedDataType = nil
                                }
                            }
                        }
                }else{
                    DataMainView()
                }
            }
        }
    }
}

#Preview {
    DataView()
        .environmentObject(DataManager.shared)
}
