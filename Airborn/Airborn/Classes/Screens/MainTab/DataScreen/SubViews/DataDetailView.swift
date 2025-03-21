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
                VStack{
                    HStack{
                        ForEach(Constants.dataFilterType.allCases, id: \.rawValue) { item in
                            Button(action: {
                                dataManager.filterType = item
                            }) {
                                Text(item.rawValue)
                                    .textStyle(DataPillButtonTextStyle())
                                    .padding(8)
                                    .background(dataManager.filterType == item ? Constants.Colour.PrimaryBlue : Constants.Colour.GrayishWhite)
                                    .clipShape(Capsule())
                                    .shadow(radius: 5)
                            }
                        }
                        Spacer()
                    }
                    
                    DataChartView(sensorType: datatype)
                }
                .dataBoxStyle(title:"Recent Exposure", titleIn: false)

            }
        }
    }
}

#Preview {
    DataDetailView()
        .environmentObject(DataManager.shared)
}
