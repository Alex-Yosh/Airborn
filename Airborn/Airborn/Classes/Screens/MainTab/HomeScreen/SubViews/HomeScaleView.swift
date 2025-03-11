//
//  HomeScaleView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-20.
//

import SwiftUI

struct HomeScaleView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    @State private var animatedProgress: Float = 0
    @State private var animationTimer: Timer? = nil

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let radius = size * 0.45
            
            let arcStart: CGFloat = 0.3
            let arcEnd: CGFloat = 0.9
            
            // Calculate Needle Positioning
            let angle = getNeedleAngle(progress: animatedProgress) - 90
            let radians = angle * .pi / 180
            
            let circleRadius = size * 0.5
            let circleX = cos(radians) * circleRadius
            let circleY = sin(radians) * circleRadius
            
            // Needle slightly inward
            let needleRadius = size * 0.40
            let needleX = cos(radians) * needleRadius
            let needleY = sin(radians) * needleRadius
            
            ZStack {
                // Background Gauge Arc
                Circle()
                    .trim(from: arcStart, to: arcEnd)
                    .stroke(style: StrokeStyle(lineWidth: size * 0.09, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.black)
                    .rotationEffect(.degrees(55))
                
                Circle()
                    .trim(from: arcStart, to: arcEnd)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(stops: [
                                .init(color: Constants.Colour.HomeScaleStrongerGreen, location: 0.25),
                                .init(color: Constants.Colour.HomeScaleGreenishYellow, location: 0.45),
                                .init(color: Constants.Colour.HomeScaleStrongYellow, location: 0.60),
                                .init(color: Constants.Colour.HomeScaleDarkerOrange, location: 0.75),
                                .init(color: Constants.Colour.HomeScaleStrongRed, location: 0.90)
                            ]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round, lineJoin: .round)
                    )
                    .rotationEffect(.degrees(55))
                
                // AQI Value & Category Label
                VStack {
                    if let latestData = dataManager.latestSensorData {
                        Text("\(Int(latestData.calculateAQI()))")
                            .textStyle(HomeScaleAQIbigTextStyle())
                    }
                    
                    Text(aqiCategory(progress: animatedProgress))
                        .textStyle(HomeScaleAQIsmallTextStyle())
                        .foregroundColor(aqiCategoryColor(progress: animatedProgress))
                    
                    Text("AQI")
                        .textStyle(HomeScaleAQIsmallTextStyle())
                        .foregroundColor(.black)
                }
                
                // Circular Indicator & Needle
                ZStack {
                    // Triangle Needle
                    Needle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: size * 0.04, height: size * 0.05)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                        .rotationEffect(.degrees(angle + 90))
                        .position(x: geometry.size.width / 2 + needleX, y: geometry.size.height / 2 + needleY)
                    
                    // Circular Indicator
                    Circle()
                        .frame(width: size * 0.08, height: size * 0.08)
                        .foregroundColor(Color.white)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: size * 0.015)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                        .position(x: geometry.size.width / 2 + circleX, y: geometry.size.height / 2 + circleY)
                }
            }
            .offset(y: circleRadius / 2.5)
        }
        .onAppear {
            if let latestData = dataManager.latestSensorData{
                startAnimatingProgress(progress: Float(latestData.calculateAQIPercentage()))
            }
        }
        .onReceive(dataManager.$latestSensorData) { newData in
            if let newData = newData{
                startAnimatingProgress(progress: Float(newData.calculateAQIPercentage()))
            }
        }
    }
    
    // Function to smoothly animate needle movement
    private func startAnimatingProgress(progress: Float) {
        animationTimer?.invalidate() // Stop any running timer
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            let step: Float = 0.01
            
            if abs(progress - animatedProgress) < step {
                animatedProgress = progress
                timer.invalidate()
            } else {
                animatedProgress += (progress - animatedProgress) * 0.1
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
            return "Unhealthy"
        case 0.81...1:
            return "Hazardous"
        default:
            return ""
        }
    }
    
    // Function to get color based on AQI category
    func aqiCategoryColor(progress: Float) -> Color {
        switch progress {
        case 0...0.2:
            return Constants.Colour.HomeScaleStrongerGreen
        case 0.21...0.4:
            return Constants.Colour.HomeScaleGreenishYellow
        case 0.41...0.6:
            return Constants.Colour.HomeScaleStrongYellow
        case 0.61...0.8:
            return Constants.Colour.HomeScaleDarkerOrange
        default:
            return Constants.Colour.HomeScaleStrongRed
        }
    }
    
    func getNeedleAngle(progress: Float) -> CGFloat {
        let minAngle: CGFloat = -107.5 // Adjusted for larger arc
        let maxAngle: CGFloat = 107.5  // Adjusted for larger arc
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

