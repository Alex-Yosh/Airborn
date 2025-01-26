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
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .textStyle(DataHeadingTextStyle())
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .textStyle(DataSubHeadingTextStyle())
        }
    }
}

#Preview {
    DataDetailView()
        .environmentObject(DataManager.shared)
}
