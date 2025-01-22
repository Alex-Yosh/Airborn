//
//  DataView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct DataView: View {
    
    let exdata = [SensorData(id: UUID(), sensorId: UUID(), temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, date: Date()),
                  SensorData(id: UUID(), sensorId: UUID(), temperature: 21.0, humidity: 48, pm25: 15, tvoc: 1.2, co2: 420, date: Date().addingTimeInterval(-480000)),
                  SensorData(id: UUID(), sensorId: UUID(), temperature: 22.3, humidity: 46, pm25: 8, tvoc: 1.1, co2: 410, date: Date().addingTimeInterval(-320000))]
    
    var body: some View {
        ZStack{
            Constants.Colour.SecondaryLightGray.ignoresSafeArea()
            ScrollView(){
                HStack{
                    Text("My Exposure")
                        .textStyle(HeadingTextStyle())
                    Spacer()
                }.padding()
                VStack(spacing: 16){
                    HStack{
                        DataTempView()
                            .dataBoxStyle(title: "Temperature")
                        
                        DataHumidityView()
                            .dataBoxStyle(title: "Humidity")
                    }
                    
                    
                    DataChartView(sensorData: exdata, sensorType: Constants.dataTypes.pm25)
                        .dataBoxStyle(title: Constants.dataTypes.pm25.rawValue)
                    
                }
            }
        }
    }
}



struct DataBoxStyle: ViewModifier {
    
    var title: String
    
    static var fontSize = 16.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
            VStack{
                
                Text(title)
                    .textStyle(DataHeadingTextStyle()).padding()
                Spacer()
                content
                Spacer()
            }
        }.padding(.horizontal)
    }
}

extension View {
    func dataBoxStyle(title: String) -> some View {
        modifier(DataBoxStyle(title: title))
    }
}

#Preview {
    DataView()
}
