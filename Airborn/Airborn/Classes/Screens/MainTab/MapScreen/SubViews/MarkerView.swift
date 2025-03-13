//
//  MarkerView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-26.
//

import SwiftUI
import MapKit

struct MarkerView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    var sensor: Sensor
    
    var body: some View {
        Button(action: {
            mapManager.ShowSensorSheet(sensor: sensor)
            mapManager.centerMapOnSensor(sensor: sensor)
            
        }, label: {
            ZStack() {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                Triangle()
                    .foregroundColor(.red)
                    .frame(width: 15, height: 10)
                    .offset(y:7)
                Image(systemName: "air.purifier")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
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
    MarkerView(sensor:Sensor(id: UUID(), name: "test", latitude: 43.474823, longitude: -80.536141))
}
