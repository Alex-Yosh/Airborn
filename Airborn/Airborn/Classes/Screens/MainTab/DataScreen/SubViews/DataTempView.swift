//
//  DataTempView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-15.
//

import SwiftUI

struct DataTempView: View {
    var body: some View {
        
        DataScaleView(progressPercent: getPercent(temp: 22), temp: 22).frame(width: 100, height: 100)
        
        
    }
    
    func getPercent(temp: Int) -> Float{
        if temp < 16{
            return 0.0
        }
        else if temp > 28{
            return 100.0
        }
        
        return ((Float(temp)-16.0)/12.0)
    }
}



struct DataScaleView: View {
    @State var progressPercent: Float = 0.5
    
    var temp: Int
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var StartingProgress: Float = 0
    @State private var degress: Double = -110
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.25, to: 0.95)
                .stroke(style: StrokeStyle(lineWidth: 16.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(54.5))
            
            Circle()
                .trim(from: 0.25, to: CGFloat(0.25 + StartingProgress*0.7))
                .stroke(style: StrokeStyle(lineWidth: 16.0, lineCap: .round, lineJoin: .round))
                .fill(AngularGradient(gradient: Gradient(stops: [
                    .init(color: Constants.Colour.ScaleBlue, location: 0.25),
                    .init(color: Constants.Colour.ScaleYellow, location: 0.45),
                    .init(color: Constants.Colour.ScaleLightOrange, location: 0.60),
                    .init(color: Constants.Colour.ScaleDarkOrange, location: 0.75),
                    .init(color: Constants.Colour.ScaleRed, location: 0.95)]), center: .center))
                .rotationEffect(.degrees(54.5))
                .animation(.easeInOut, value: StartingProgress)
            
            VStack{
                Text(String(temp) + "°C")
                    .textStyle(RegularTextStyle())
                    .lineLimit(1)
            }
            .onReceive(timer) { _ in
                withAnimation {
                    if StartingProgress < (9*progressPercent/10) {
                        StartingProgress += (progressPercent/10)
                    }else{
                        StartingProgress = progressPercent
                    }
                }
            }
        }
    }
}

#Preview {
    DataTempView()
}
