//
//  MapDataDetailView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-21.
//

import SwiftUI

struct MapDataDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        VStack(spacing: 16){
            
            MapChartView(sensorType: Constants.dataTypes.pm25)
                .dataBoxStyle(title: Constants.dataTypes.pm25.rawValue, titleIn: true)
            
            MapChartView(sensorType: Constants.dataTypes.tvoc)
                .dataBoxStyle(title: Constants.dataTypes.tvoc.rawValue, titleIn: true)
            
            MapChartView(sensorType: Constants.dataTypes.co2)
                .dataBoxStyle(title: Constants.dataTypes.co2.rawValue, titleIn: true)
        }
        
    }
}

#Preview {
    MapDataDetailView()
        .environmentObject(DataManager.shared)
}
