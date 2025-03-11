//
//  HomeBarView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-10.
//

import SwiftUI

struct HomeBarView: View {
    var title: String
    var value: Double
    var unit: String
    var progress: Float
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            HStack {
                Text(title)
                    .textStyle(SubHeadingTextStyle())

                Spacer()
                Text("\(Int(value)) \(unit)")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            
            VStack(spacing: 2) {
                ZStack(alignment: .leading) {
                    GeometryReader { geo in
                        let barWidth = geo.size.width
                        let segmentCount = 5
                        let segmentSpacing: CGFloat = 3
                        let segmentWidth = (barWidth - CGFloat(segmentCount - 1) * segmentSpacing) / CGFloat(segmentCount)
                        
                        // Full Gradient Bar
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue, Color.cyan, Color.green, Color.yellow, Color.orange, Color.red
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 12)
                            .mask(
                                // Masking the gradient to make it appear segmented
                                HStack(spacing: segmentSpacing) {
                                    ForEach(0..<segmentCount, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: segmentWidth, height: 12)
                                    }
                                }
                            )
                        
                        Needle()
                            .rotation(.degrees(180))
                            .frame(width: 12, height: 10)
                            .position(x: max(6, min(barWidth - 6, CGFloat(progress) * barWidth)), y: -5)
                    }
                    .frame(height: 12)
                }
                .padding(.vertical, 4)
                
                // Labels
                HStack {
                    Text("Low")
                        .textStyle(BarLowHighTextStyle())
                    Spacer()
                    Text("High")
                        .textStyle(BarLowHighTextStyle())
                }
            }
        }
    }
}

#Preview {
    HomeBarView(title: "VOC", value: 50, unit: "µg/m3", progress: 0.2)
}


