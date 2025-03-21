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
    @State var colour: Color?
    @State private var rippleEffect = false
    
    var body: some View {
        ZStack {
            if let colour = colour {
                
                if mapManager.bottomSheetSensor == sensor {
                    ZStack {
                        Circle()
                            .stroke(colour.opacity(0.5), lineWidth: 4)
                            .frame(width: 60, height: 60)
                            .scaleEffect(rippleEffect ? 1.6 : 1.0)
                            .opacity(rippleEffect ? 0.0 : 0.5)
                            .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: rippleEffect)
                        
                        Circle()
                            .stroke(colour.opacity(0.3), lineWidth: 3)
                            .frame(width: 50, height: 50)
                            .scaleEffect(rippleEffect ? 1.4 : 1.0)
                            .opacity(rippleEffect ? 0.0 : 0.3)
                            .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: false).delay(0.5), value: rippleEffect)
                    }
                }
                
                Circle()
                    .fill(colour.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .blur(radius: 6) // Soft glow
                
                Button(action: {
                    if mapManager.bottomSheetSensor == sensor {
                        mapManager.HideSensorSheet()
                    } else {
                        mapManager.ShowSensorSheet(sensor: sensor)
                        mapManager.centerMapOnSensor(sensor: sensor)
                        rippleEffect = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            rippleEffect = true
                        }
                    }
                }) {
                    VStack(spacing: -7) {
                        ZStack {
                            Circle()
                                .fill(colour)
                                .frame(width: 28, height: 28)
                                .shadow(color: colour.opacity(0.5), radius: 4, x: 0, y: 2)
                            
                            Image("Sensor")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                        
                        Triangle()
                            .fill(colour)
                            .frame(width: 12, height: 14)
                            .offset(y: -2)
                            .shadow(color: colour.opacity(0.4), radius: 3, x: 0, y: 1)
                    }
                }
            }
        }
        .onChange(of: mapManager.bottomSheetSensor) { _, _ in
            if mapManager.bottomSheetSensor == sensor {
                rippleEffect = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    rippleEffect = true
                }
            }
        }
        .onAppear {
            mapManager.fetchSensorColour(for: sensor) { sensorColour in
                DispatchQueue.main.async {
                    colour = sensorColour
                }
            }
        }
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
    let mockMapManager = MapManager.shared
    let testSensor = Sensor(id: UUID(), name: "Test Sensor", latitude: 43.474823, longitude: -80.536141)
    
    DispatchQueue.main.async {
        mockMapManager.bottomSheetSensor = testSensor
    }
    
    return MarkerView(sensor: testSensor)
        .environmentObject(mockMapManager)
}
