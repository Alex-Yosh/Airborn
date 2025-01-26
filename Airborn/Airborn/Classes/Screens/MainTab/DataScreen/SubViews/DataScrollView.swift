//
//  DataScrollView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-25.
//

import SwiftUI

struct DataScrollView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    let exdata = [SensorData(id: UUID(), sensorId: UUID(), temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, date: Date()),
                  SensorData(id: UUID(), sensorId: UUID(), temperature: 21.0, humidity: 48, pm25: 15, tvoc: 1.2, co2: 420, date: Date().addingTimeInterval(-480000)),
                  SensorData(id: UUID(), sensorId: UUID(), temperature: 22.3, humidity: 46, pm25: 8, tvoc: 1.1, co2: 410, date: Date().addingTimeInterval(-320000))]
    
    var body: some View {
        ScrollView(showsIndicators: false){
            HStack{
                Text("My Exposure")
                    .textStyle(HeadingTextStyle())
                Spacer()
            }.padding([.horizontal, .bottom])
            VStack(spacing: 16){
                HStack{
                    DataTempView()
                        .dataBoxStyle(title: "Temperature")
                    
                    DataHumidityView()
                        .dataBoxStyle(title: "Humidity")
                }
                
                DataChartScaleCellView(sensorData: exdata, sensorType: Constants.dataTypes.pm25)
                    .dataBoxStyle(title: Constants.dataTypes.pm25.rawValue)
                
                DataChartScaleCellView(sensorData: exdata, sensorType: Constants.dataTypes.tvoc)
                    .dataBoxStyle(title: Constants.dataTypes.tvoc.rawValue)
                
                DataChartScaleCellView(sensorData: exdata, sensorType: Constants.dataTypes.co2)
                    .dataBoxStyle(title: Constants.dataTypes.co2.rawValue)
                
            }
        }
    }
}

#Preview {
    DataScrollView()
        .environmentObject(DataManager.shared)
}
