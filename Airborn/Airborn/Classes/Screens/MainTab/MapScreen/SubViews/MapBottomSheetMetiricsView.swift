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
                    MapBottomSheetMetricLabelView(title: Constants.dataTypes.pm25.rawValue, value:
                                                    "\(round(sensorData.pm25 * 10) / 10.0) \(Constants.dataTypes.pm25.metric)"
                                                    , progressPercent: 1)
                    MapBottomSheetMetricLabelView(title: Constants.dataTypes.tvoc.rawValue, value: "\(round(sensorData.tvoc * 10) / 10.0) \(Constants.dataTypes.tvoc.metric)", progressPercent: 0.7)
                }
                GridRow {
                    MapBottomSheetMetricLabelView(title: Constants.dataTypes.co2.rawValue, value: "\(round(sensorData.co2 * 10) / 10.0) \(Constants.dataTypes.co2.metric)", progressPercent: 0.3)
                }
            }
            
            
        }.padding()
    }
}

#Preview {
    MapBottomSheetMetricsView(sensorData: SensorData(temperature: 21.0, humidity: 23.0, pm25: 4.1, tvoc: 3.2, co2: 2.0, timestamp: Date.now))
}
