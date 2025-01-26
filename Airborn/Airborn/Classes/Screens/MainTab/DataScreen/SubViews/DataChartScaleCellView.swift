//
//  DataChartScaleCellView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-22.
//

import SwiftUI

struct DataChartScaleCellView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    let sensorData: [SensorData]
    let sensorType: Constants.dataTypes
    
    var body: some View {
        Button(action: {
            dataManager.selectedDataType = sensorType
        }){
            VStack{
                DataChartView(sensorData: sensorData, sensorType: sensorType)
                HStack{
                    Text("average: 10 \(sensorType.metric)")
                        .textStyle(RegularTextStyle())
                    Spacer()
                    ScaleBarView()
                }.padding()
            }
        }
    }
}

#Preview {
    DataChartScaleCellView(sensorData: [SensorData(id: UUID(), sensorId: UUID(), temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, date: Date()),
                                        SensorData(id: UUID(), sensorId: UUID(), temperature: 21.0, humidity: 48, pm25: 15, tvoc: 1.2, co2: 420, date: Date().addingTimeInterval(-480000)),
                                        SensorData(id: UUID(), sensorId: UUID(), temperature: 22.3, humidity: 46, pm25: 8, tvoc: 1.1, co2: 410, date: Date().addingTimeInterval(-320000))], sensorType: Constants.dataTypes.pm25)
    .environmentObject(DataManager.shared)
}
