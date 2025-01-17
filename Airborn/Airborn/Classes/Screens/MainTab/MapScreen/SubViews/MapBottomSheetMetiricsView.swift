//
//  MapBottomSheetMetricView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-04.
//

import SwiftUI

struct MapBottomSheetMetricsView: View {
    
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
                    MapBottomSheetMetricLabelView(title: "PM2.5", value: String(round(sensorData.pm25 * 10) / 10.0) + " µg/m³", progressPercent: 1)
                    MapBottomSheetMetricLabelView(title: "TVOC", value: String(round(sensorData.tvoc * 10) / 10.0) + " ppb", progressPercent: 0.7)
                }
                GridRow {
                    MapBottomSheetMetricLabelView(title: "CO2", value: String(round(sensorData.co2 * 10) / 10.0) + " ppm", progressPercent: 0.3)
                }
            }
            
            
        }.padding()
    }
}

#Preview {
    MapBottomSheetMetricsView(sensorData: SensorData(id: UUID(), sensorId: UUID(), temperature: 21.0, humidity: 23.0, pm25: 4.1, tvoc: 3.2, co2: 2.0, date: Date.now))
}
