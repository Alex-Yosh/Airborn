//
//  DataDetailView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-25.
//

import SwiftUI

struct DataDetailView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack{
            
            HStack{
                Text("This is a general description for the element")
                    .textStyle(RegularTextStyle())
                Spacer()
            }
            .dataBoxStyle(title:"Description", titleIn: false)
            
            HStack{
                Text("What are the standards for this element, how will we quantify?")
                    .textStyle(RegularTextStyle())
                Spacer()
            }
            .dataBoxStyle(title:"What is a good reading?", titleIn: false)
            
            DataChartView(sensorData: dataManager.data, sensorType: dataManager.selectedDataType ?? .co2)
                .dataBoxStyle(title:"Recent Exposure", titleIn: false)
            
            VStack{
                Grid {
                    GridRow {
                        Text("Last 7 days")
                            .textStyle(RegularTextStyle())
                        Text("10 \(dataManager.selectedDataType?.metric ?? "")")
                            .textStyle(RegularTextStyle())
                        ScaleBarView()
                    }.padding(.vertical, 8)
                    
                    Divider()
                    
                    GridRow {
                        Text("Last 14 days")
                            .textStyle(RegularTextStyle())
                        Text("10 \(dataManager.selectedDataType?.metric ?? "")")
                            .textStyle(RegularTextStyle())
                        ScaleBarView()
                    }.padding(.vertical, 8)
                    Divider()
                    
                    GridRow {
                        Text("Last 31 days")
                            .textStyle(RegularTextStyle())
                        Text("10 \(dataManager.selectedDataType?.metric ?? "")")
                            .textStyle(RegularTextStyle())
                        ScaleBarView()
                    }.padding(.vertical, 8)
                    
                    
                }
            }
            .dataBoxStyle(title:"Trends", titleIn: false)
        }
        
    }
}

#Preview {
    DataDetailView()
        .environmentObject(DataManager.shared)
}
