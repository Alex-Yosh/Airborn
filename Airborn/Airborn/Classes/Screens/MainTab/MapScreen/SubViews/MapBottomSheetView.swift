//
//  MapBottomSheetView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-03.
//

import SwiftUI

struct MapBottomSheetView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
                if let sensor = mapManager.selectedSensor{
                        HStack{
                            VStack{
                                Text(sensor.name)
                                    .textStyle(HeadingTextStyle())
                                HStack{
                                    MapBottomSheetLabelView(image: "thermometer.high", text: String(round(sensor.temp * 10) / 10.0) + "°C")
                                    MapBottomSheetLabelView(image: "humidity", text: String(round(sensor.humidity * 10) / 10.0) + "RH")
                                }
                            }
                            Spacer()
                            Image(systemName: "air.purifier")
                                .font(.system(size: 60))
                        }.padding()
                        
                        MapBottomSheetMetricsView(sensor: sensor)
                    
                }else{
                    Text("Cannot Find Sensor")
                }
            
    }
}

#Preview {
    MapBottomSheetView()
        .environmentObject(MapManager.shared)
}
