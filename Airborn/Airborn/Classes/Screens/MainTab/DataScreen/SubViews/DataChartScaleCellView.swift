//
//  DataChartScaleCellView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-22.
//

import SwiftUI

struct DataChartScaleCellView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    let sensorType: Constants.dataTypes
    
    var body: some View {
        Button(action: {
            dataManager.selectedDataType = sensorType
        }){
            VStack{
                DataChartView(sensorData: dataManager.data, sensorType: sensorType)
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
    DataChartScaleCellView( sensorType: Constants.dataTypes.pm25)
        .environmentObject(DataManager.shared)
}
