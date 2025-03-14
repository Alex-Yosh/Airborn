//
//  HomeView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ZStack{
            //top gradiant
            LinearGradient(colors: [Constants.Colour.PrimaryBlue, .white], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack(spacing: 12) {
                HomeTopTextView()
                
                // Check if data is loaded
                if let latestData = dataManager.latestSensorData {
                    TemperatureHumidityView(temperature: latestData.temperature, humidity: latestData.humidity)
                        .homeBoxStyle()

                    HomeScaleView()
                        .border(.red)
                
                    VStack(spacing: 8) {
                        HomeBarView(title: "TVOC", value: latestData.tvoc, unit: "", progress: latestData.getQualityPercentage(ofType: .tvoc))
                            .homeBoxStyle()
                        HomeBarView(title: "PM2.5", value: latestData.pm25, unit: Constants.dataTypes.pm25.metric, progress: latestData.getQualityPercentage(ofType: .pm25))
                            .homeBoxStyle()
                        HomeBarView(title: "CO2", value: latestData.co2, unit: Constants.dataTypes.co2.metric, progress: latestData.getQualityPercentage(ofType: .co2))
                            .homeBoxStyle()
                    }
                    
                } 
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(DataManager.shared)
        .environmentObject(MapManager.shared)
}
