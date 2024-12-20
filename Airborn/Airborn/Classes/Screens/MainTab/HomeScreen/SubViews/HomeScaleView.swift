//
//  HomeScaleView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-20.
//

import SwiftUI

struct HomeScaleView: View {
    @State var progressPercent: Float = 0.5
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var StartingProgress: Float = 0
    @State private var degress: Double = -110
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.25, to: 0.95)
                .stroke(style: StrokeStyle(lineWidth: 32.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(54.5))
            
            Circle()
                .trim(from: 0.25, to: CGFloat(0.25 + StartingProgress*0.7))
                .stroke(style: StrokeStyle(lineWidth: 32.0, lineCap: .round, lineJoin: .round))
                .fill(AngularGradient(gradient: Gradient(stops: [
                    .init(color: Constants.Colour.ScaleRed, location: 0.25),
                    .init(color: Constants.Colour.ScaleDarkOrange, location: 0.45),
                    .init(color: Constants.Colour.ScaleLightOrange, location: 0.60),
                    .init(color: Constants.Colour.ScaleYellow, location: 0.75),
                    .init(color: Constants.Colour.ScaleGreen, location: 0.95)]), center: .center))
                .rotationEffect(.degrees(54.5))
                .animation(.easeInOut, value: StartingProgress)
            
            VStack{
                Text("\(progressPercent*100, specifier: "%.1f") %").font(Font.system(size: 44)).bold()
                Text(captionText(progress: progressPercent)).bold().foregroundColor(captionColor(progress: progressPercent))
            }
        }.padding(.horizontal, 36)
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
    
    func captionText(progress: Float) ->String{
        switch(progress)
        {
        case 0...0.2:
            return "Really Bad Exposure"
        case 0.21...0.4:
            return "Bad Exposure"
        case 0.41...0.6:
            return "Decent Exposure"
        case 0.61...0.8:
            return "Good Exposure"
        default:
            return "Excellent Exposure!"
        }
    }
    
    func captionColor(progress: Float) -> Color{
        switch(progress)
        {
        case 0...0.2:
            return Constants.Colour.ScaleRed
        case 0.21...0.4:
            return Constants.Colour.ScaleDarkOrange
        case 0.41...0.6:
            return Constants.Colour.ScaleLightOrange
        case 0.61...0.8:
            return Constants.Colour.ScaleYellow
        default:
            return Constants.Colour.ScaleGreen
        }
    }
    
}

#Preview {
    HomeScaleView()
}
