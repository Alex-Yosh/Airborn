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
        if let datatype = dataManager.selectedDataType{
            VStack{
                
                // Description
                HStack{
                    Text(datatype.description)
                        .textStyle(RegularTextStyle())
                    Spacer()
                }
                .dataBoxStyle(title:"Description", titleIn: false)
                
                // What is a good reading?
                if (datatype == .co2 || datatype == .pm25){
                    HStack{
                        Text(datatype.standards)
                            .textStyle(RegularTextStyle())
                        Spacer()
                    }
                    .dataBoxStyle(title:"What is a good reading?", titleIn: false)
                }
                
                DataChartView(sensorType: datatype)
                    .dataBoxStyle(title:"Recent Exposure", titleIn: false)
                
                VStack{
                    Grid {
                        GridRow {
                            Text("Last 7 days")
                                .textStyle(RegularTextStyle())
                            Text("10 \(datatype.metric)")
                                .textStyle(RegularTextStyle())
                            ScaleBarView()
                        }.padding(.vertical, 8)
                        
                        Divider()
                        
                        GridRow {
                            Text("Last 14 days")
                                .textStyle(RegularTextStyle())
                            Text("10 \(datatype.metric)")
                                .textStyle(RegularTextStyle())
                            ScaleBarView()
                        }.padding(.vertical, 8)
                        Divider()
                        
                        GridRow {
                            Text("Last 31 days")
                                .textStyle(RegularTextStyle())
                            Text("10 \(datatype.metric)")
                                .textStyle(RegularTextStyle())
                            ScaleBarView()
                        }.padding(.vertical, 8)
                        
                        
                    }
                }
                .dataBoxStyle(title:"Trends", titleIn: false)
            }
        }
    }
}

#Preview {
    DataDetailView()
        .environmentObject(DataManager.shared)
}
