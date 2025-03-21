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
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    if let selected = dataManager.selectedDataType {
                        DataDetailView()
                            .id("top") // Assign a scroll ID for resetting
                            .navigationTitle(selected.rawValue)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Back") {
                                        dataManager.selectedDataType = nil
                                    }
                                }
                            }
                            .onAppear {
                                proxy.scrollTo("top", anchor: .top) // Reset scroll when reopened
                            }
                    } else {
                        DataMainView()
                    }
                }
            }
        }
    }
}

#Preview {
    DataView()
        .environmentObject(DataManager.shared)
}
