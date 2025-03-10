//
//  HomeScaleView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-20.
//

import SwiftUI

struct HomeScaleView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var progressPercent: Float = 0.7
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var startingProgress: Float = 0
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let radius = size * 0.42 // Adjusted radius for better fit
            let circleRadius = size * 0.5 // Adjusted circle radius to fit arc
            
            // Calculate Angle and Position
            let angle = getNeedleAngle(progress: progressPercent) - 90 // Offset by 90° for correct positioning
            let radians = angle * .pi / 180
            
            let circleX = cos(radians) * circleRadius
            let circleY = sin(radians) * circleRadius
            
            // Needle slightly inward
            let needleRadius = size * 0.40
            let needleX = cos(radians) * needleRadius
            let needleY = sin(radians) * needleRadius
            
            ZStack {
                // Background Gauge Arc
                Circle()
                    .trim(from: 0.35, to: 0.85)
                    .stroke(style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.gray.opacity(0.3))
                    .rotationEffect(.degrees(55)) // Corrected rotation
                
                // Color Gradient Gauge Arc
                Circle()
                    .trim(from: 0.35, to: 0.85)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(red: 0.3, green: 0.9, blue: 0.5), location: 0.35), // Stronger Green
                                .init(color: Color(red: 0.7, green: 1.0, blue: 0.6), location: 0.45), // Greenish Yellow
                                .init(color: Color(red: 1.0, green: 0.9, blue: 0.3), location: 0.60), // Strong Yellow
                                .init(color: Color(red: 1.0, green: 0.7, blue: 0.2), location: 0.75), // Darker Orange
                                .init(color: Color(red: 0.9, green: 0.2, blue: 0.1), location: 0.85)  // Strong Red
                            ]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round)
                    )
                    .rotationEffect(.degrees(55))
                
                // AQI Value & Category Label
                VStack {
                    if let latestData = dataManager.latestSensorData{
                        Text("\(Int(latestData.calculateAQI()))")
                            .font(.system(size: size * 0.15, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                    Text(aqiCategory(progress: progressPercent))
                        .font(.system(size: size * 0.06, weight: .semibold))
                        .foregroundColor(aqiCategoryColor(progress: progressPercent))
                    
                    Text("AQI")
                        .font(.system(size: size * 0.05, weight: .medium))
                        .foregroundColor(Color.gray.opacity(0.9))
                }
                
                // Circular Indicator & Needle
                ZStack {
                    // Triangle Needle (Placed Below the Circle)
                    Needle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: size * 0.04, height: size * 0.05)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                        .rotationEffect(.degrees(angle + 90)) // Rotate correctly towards the arc
                        .position(x: geometry.size.width / 2 + needleX, y: geometry.size.height / 2 + needleY) // Perfect alignment
                    
                    // Circular Indicator (Perfectly Following the Arc)
                    Circle()
                        .frame(width: size * 0.08, height: size * 0.08)
                        .foregroundColor(Color.white)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: size * 0.015) // Thicker outline
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                        .position(x: geometry.size.width / 2 + circleX, y: geometry.size.height / 2 + circleY)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                if startingProgress < (9 * progressPercent / 10) {
                    startingProgress += (progressPercent / 10)
                } else {
                    startingProgress = progressPercent
                }
            }
        }
    }
    
    // Function to get AQI category based on progress
    func aqiCategory(progress: Float) -> String {
        switch progress {
        case 0...0.2:
            return "Excellent"
        case 0.21...0.4:
            return "Good"
        case 0.41...0.6:
            return "Decent"
        case 0.61...0.8:
            return "Moderate"
        default:
            return "Unhealthy"
        }
    }
    
    // Function to get color based on AQI category
    func aqiCategoryColor(progress: Float) -> Color {
        switch progress {
        case 0...0.2:
            return Color(red: 0.3, green: 0.9, blue: 0.5) // Strong Green
        case 0.21...0.4:
            return Color(red: 0.7, green: 1.0, blue: 0.6) // Greenish Yellow
        case 0.41...0.6:
            return Color(red: 1.0, green: 0.9, blue: 0.3) // Strong Yellow
        case 0.61...0.8:
            return Color(red: 1.0, green: 0.7, blue: 0.2) // Darker Orange
        default:
            return Color(red: 0.9, green: 0.2, blue: 0.1) // Stronger Red
        }
    }
    
    // Function to determine indicator angle (Now Uses Radians)
    func getNeedleAngle(progress: Float) -> CGFloat {
        let minAngle: CGFloat = -90 // Adjusted for perfect arc
        let maxAngle: CGFloat = 90  // Adjusted for perfect arc
        return (minAngle + (maxAngle - minAngle) * CGFloat(progress))
    }
}

// Custom Triangle Shape for the Needle
struct Needle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    HomeScaleView()
        .environmentObject(DataManager.shared)
}
