//
//  MapBottomSheetView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-03.
//

import SwiftUI

struct MapBottomSheetView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    //TODO: get data from database to replace this
    let exampleSensorData = SensorData(temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, timestamp: Date())
    
    var body: some View {
                if let sensor = mapManager.selectedSensor{
                        HStack{
                            VStack{
                                Text(sensor.name)
                                    .textStyle(HeadingTextStyle())
                                HStack{
                                    MapBottomSheetLabelView(image: "thermometer.high", text: String(round(exampleSensorData.temperature * 10) / 10.0) + Constants.dataTypes.temperature.metric)
                                    MapBottomSheetLabelView(image: "humidity", text: String(round(exampleSensorData.humidity * 10) / 10.0) + Constants.dataTypes.humidity.metric)
                                }
                            }
                            Spacer()
                            Image(systemName: "air.purifier")
                                .font(.system(size: 60))
                        }.padding()
                        
                    MapBottomSheetMetricsView(sensorData: exampleSensorData)
                    
                }else{
                    Text("Cannot Find Sensor")
                }
            
    }
}

#Preview {
    MapBottomSheetView()
        .environmentObject(MapManager.shared)
}
