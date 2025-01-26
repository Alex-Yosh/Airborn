//
//  DataDetailView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-25.
//

import SwiftUI

struct DataDetailView: View {

    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        VStack{
            
            Text("hi")
                .dataBoxStyle(title:Constants.dataTypes.pm25.rawValue, titleIn: false)
        }
    }
}

#Preview {
    DataDetailView()
        .environmentObject(DataManager.shared)
}
