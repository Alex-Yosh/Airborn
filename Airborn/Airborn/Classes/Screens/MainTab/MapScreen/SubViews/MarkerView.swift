//
//  MarkerView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-26.
//

import SwiftUI

struct MarkerView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    var sensor: SensorData
    
    var body: some View {
        Button(action: {
            mapManager.ShowSensorSheet(sensor: sensor)
        }, label: {
            ZStack() {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 100, height: 100)
                Triangle()
                    .foregroundColor(.red)
                    .frame(width: 75, height: 100)
                    .offset(y:30)
                Image(systemName: "air.purifier")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
            .compositingGroup()
        })
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}


#Preview {
    MarkerView(sensor: SensorData(name: "name",lastUpdated: Date.now, lat: 43.873916, long: -79.243139, battery: 100.0, temp: 21.0, humidity: 23.0, PM25: 0.0, TVOC: 0.0, CO2: 0.0))
}
