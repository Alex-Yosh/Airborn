//
//  MapBottomSheetMetricView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-04.
//

import SwiftUI

struct MapBottomSheetMetricsView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    var sensorData: SensorData
    
    var body: some View {
        VStack{
            HStack{
                Text("What is the air quality like?")
                    .textStyle(MapQuestionTextStyle())
                
                Spacer()
            }
            Grid() {
                GridRow {
                    MapBottomSheetMetricLabelView(title: Constants.dataTypes.pm25.rawValue
                                                  , progressPercent: sensorData.getQualityPercentage(ofType: Constants.dataTypes.pm25))
                    MapBottomSheetMetricLabelView(title: Constants.dataTypes.tvoc.rawValue, progressPercent: sensorData.getQualityPercentage(ofType: Constants.dataTypes.tvoc))
                }
                GridRow {
                    MapBottomSheetMetricLabelView(title: Constants.dataTypes.co2.rawValue, progressPercent: sensorData.getQualityPercentage(ofType: Constants.dataTypes.co2))
                    
                    LongButtonView(title: "View Details", systemImage: "", backgroundColor: Color.blue){
                        mapManager.detailSensor = mapManager.bottomSheetSensor
                        mapManager.showDetails = true
                    }
                }
            }
            
            
        }.padding()
    }
}

#Preview {
    MapBottomSheetMetricsView(sensorData: SensorData(temperature: 21.0, humidity: 23.0, pm25: 4.1, tvoc: 3.2, co2: 2.0, timestamp: Date.now))
        .environmentObject(MapManager.shared)
}
