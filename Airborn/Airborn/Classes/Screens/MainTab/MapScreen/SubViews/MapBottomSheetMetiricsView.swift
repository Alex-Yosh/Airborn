//
//  MapBottomSheetMetricView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-04.
//

import SwiftUI

struct MapBottomSheetMetricsView: View {
    
    var sensor: SensorData
    
    var body: some View {
        VStack{
            HStack{
                Text("What is the air quality like?")
                    .textStyle(MapQuestionTextStyle())
                
                Spacer()
            }
            Grid() {
                GridRow {
                    MapBottomSheetMetricLabelView(title: "PM2.5", value: String(round(sensor.PM25 * 10) / 10.0) + " µg/m³", progressPercent: 1)
                    MapBottomSheetMetricLabelView(title: "TVOC", value: String(round(sensor.TVOC * 10) / 10.0) + " ppb", progressPercent: 0.7)
                }
                GridRow {
                    MapBottomSheetMetricLabelView(title: "CO2", value: String(round(sensor.CO2 * 10) / 10.0) + " ppm", progressPercent: 0.3)
                }
            }
            
            
        }.padding()
    }
}

#Preview {
    MapBottomSheetMetricsView(sensor: SensorData(name: "name",lastUpdated: Date.now, lat: 43.873916, long: -79.243139, battery: 100.0, temp: 21.0, humidity: 23.0, PM25: 4.1, TVOC: 3.2, CO2: 2.0))
}
