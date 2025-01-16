//
//  DataHumidityView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-16.
//

import SwiftUI

struct DataHumidityView: View {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var progressPercent: Float = 0.5
    
    @State private var StartingProgress: Float = 0
    
    var body: some View {
        ZStack {
            Image(systemName: "drop.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.gray.opacity(0.2))
            
            GeometryReader { geometry in
                VStack {
                    Spacer() // Push the rectangle down
                    Rectangle()
                        .fill(Constants.Colour.PrimaryBlue)
                        .frame(height: geometry.size.height * CGFloat(StartingProgress))
                }
            }
            .mask(
                Image(systemName: "drop.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            )
        }
        .frame(width: 100, height: 100)
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

#Preview {
    DataHumidityView()
}
