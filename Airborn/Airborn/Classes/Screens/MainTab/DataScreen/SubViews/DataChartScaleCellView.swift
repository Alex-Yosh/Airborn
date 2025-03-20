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
    
    @State private var localMean: Double = 0.0
    @State private var localPercent: Float = 0.0

    var body: some View {
        Button(action: {
            dataManager.selectedDataType = sensorType
        }){
            VStack {
                DataChartView(sensorType: sensorType)
                
                HStack {
                    Text("average: \(String(format: "%.2f", localMean)) \(sensorType.metric)")
                        .textStyle(RegularTextStyle())
                        .lineLimit(1)
                    
                    Spacer()
                    
                    ScaleBarView(progressPercent: $localPercent)
                }
                .padding(.vertical)
            }
            .onChange(of: getMean()) { newMean in
                localMean = newMean
            }
            .onChange(of: getPercent()) { newPercent in
                localPercent = newPercent
            }
            .onAppear{
                localPercent = getPercent()
                localMean = getMean()
            }
        }
    }

    // ✅ Get mean value from DataManager
    private func getMean() -> Double {
        switch sensorType {
        case .co2: return dataManager.meanco2
        case .pm25: return dataManager.meanpm25
        case .tvoc: return dataManager.meantvoc
        default: return 0.0
        }
    }
    
    private func getPercent() -> Float {
        switch sensorType {
        case .co2: return dataManager.averageco2Percent
        case .pm25: return dataManager.averagepm25Percent
        case .tvoc: return dataManager.averagetvocPercent
        default: return 0.0
        }
    }
}


#Preview {
    DataChartScaleCellView(sensorType: Constants.dataTypes.co2)
        .environmentObject(DataManager.shared)
}
