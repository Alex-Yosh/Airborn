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
    
    var sensor: SensorData
    
    var body: some View {
        Button(action: {
            mapManager.ShowSensorSheet(sensor: sensor)
            mapManager.region.center = CLLocationCoordinate2D(latitude: sensor.latitude - 0.001, longitude: sensor.longitude)
            mapManager.region.span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
            
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
    MarkerView(sensor:SensorData(sensorId: UUID(), temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, date: Date()))
}
