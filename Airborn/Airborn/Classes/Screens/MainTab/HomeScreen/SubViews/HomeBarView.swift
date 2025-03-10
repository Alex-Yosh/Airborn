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
            HStack{
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text("\(Int(value)) \(unit)")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            
            ZStack(alignment: .leading) {
                // Gradient Bar with Spacing
                GeometryReader { geo in
                    let barWidth = geo.size.width
                    let segmentWidth = (barWidth - 5 * 4) / 6 // Adjust for spacing
                    
                    HStack(spacing: 4) { // Add spacing between segments
                        Color.blue.frame(width: segmentWidth)
                        Color.cyan.frame(width: segmentWidth)
                        Color.green.frame(width: segmentWidth)
                        Color.yellow.frame(width: segmentWidth)
                        Color.orange.frame(width: segmentWidth)
                        Color.red.frame(width: segmentWidth)
                    }
                    .frame(height: 12)
                    .cornerRadius(6)
                    
                    // Triangle Indicator
                    Triangle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 12, height: 10)
                        .position(x: CGFloat(1-progress) * barWidth, y: -5)
                }
                .frame(height: 12)
            }
            .padding(.vertical, 4)
            
            // Labels
            HStack {
                Text("Low")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text("High")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview {
    HomeBarView(title: "VOC", value: 50, unit: "µg/m3", progress: 0.2)
}

