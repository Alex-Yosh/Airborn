//
//  MapBottomSheetView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-03.
//

import SwiftUI

struct MapBottomSheetView: View {
    
    @EnvironmentObject var mapManager: MapManager
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        if let sensor = mapManager.selectedSensor, let sensorData = mapManager.selectedSensorData{
            HStack{
                VStack{
                    Text(sensor.name)
                        .textStyle(HeadingTextStyle())
                    HStack{
                        MapBottomSheetLabelView(image: thermometerImage(for: sensorData.temperature), text: String(round(sensorData.temperature * 10) / 10.0) + Constants.dataTypes.temperature.metric)
                        MapBottomSheetLabelView(image: "humidity", text: String(round(sensorData.humidity * 10) / 10.0) + Constants.dataTypes.humidity.metric)
                    }
                }
                Spacer()
                Image(systemName: "air.purifier")
                    .font(.system(size: 60))
            }.padding()
            
            MapBottomSheetMetricsView(sensorData: sensorData)
            
        }else{
            Text("Cannot Find Sensor")
        }
        
    }
}

#Preview {
    MapBottomSheetView()
        .environmentObject(MapManager.shared)
}
