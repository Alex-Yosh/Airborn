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
            if dataManager.selectedDataType != nil{
                DataDetailView()
            }else{
                DataScrollView()
            }
        }
    }
}

#Preview {
    DataView()
        .environmentObject(DataManager.shared)
}
