//
//  DataMainView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-25.
//

import SwiftUI

struct DataMainView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        HStack{
            Text("My Exposure")
                .textStyle(HeadingTextStyle())
            Spacer()
        }.padding([.horizontal, .bottom])
        VStack(spacing: 16){
            HStack{
                DataTempView()
                    .dataBoxStyle(title: "Temperature", titleIn: true)
                
                DataHumidityView()
                    .dataBoxStyle(title: "Humidity", titleIn: true)
            }
            
            DataChartScaleCellView(sensorType: Constants.dataTypes.pm25)
                .dataBoxStyle(title: Constants.dataTypes.pm25.rawValue, titleIn: true)
            
            DataChartScaleCellView(sensorType: Constants.dataTypes.tvoc)
                .dataBoxStyle(title: Constants.dataTypes.tvoc.rawValue, titleIn: true)
            
            DataChartScaleCellView(sensorType: Constants.dataTypes.co2)
                .dataBoxStyle(title: Constants.dataTypes.co2.rawValue, titleIn: true)
        }
        
    }
}

#Preview {
    DataMainView()
        .environmentObject(DataManager.shared)
}
