//
//  ScaleBarView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-22.
//

import Foundation
import SwiftUI

struct ScaleBarView: View {
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var StartingProgress: Float = 0
    @Binding var progressPercent: Float
    
    var body: some View {
        GeometryReader{proxy in
            VStack{
                
                ZStack{
                    Rectangle()
                        .fill(LinearGradient(colors: [Constants.Colour.ScaleRed, Constants.Colour.ScaleDarkOrange, Constants.Colour.ScaleLightOrange, Constants.Colour.ScaleYellow, Constants.Colour.ScaleGreen], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(5)
                        .frame(height: 10)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .offset(x: CGFloat(StartingProgress) * proxy.size.width*0.85 - proxy.size.width*0.45, y: 0)
                }.padding(.vertical)
                
            }
            .padding(.horizontal, proxy.size.width*0.075)
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
        .frame(height: 50)
    }
}

#Preview {
    ScaleBarView(progressPercent: .constant(0.5))
}
