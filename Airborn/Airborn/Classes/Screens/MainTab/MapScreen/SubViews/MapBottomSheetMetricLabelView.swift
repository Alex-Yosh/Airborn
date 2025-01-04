//
//  MapBottomSheetMetricLabelView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-04.
//

import SwiftUI

struct MapBottomSheetMetricLabelView: View {
    
    var title: String
    var value: String
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var StartingProgress: Float = 0
    @State var progressPercent: Float = 1
    
    var body: some View {
        GeometryReader{proxy in
            VStack{
                HStack(){
                    Text(title)
                        .textStyle(SubHeadingTextStyle())
                        .lineLimit(1)
                    Spacer()
                    Text(value)
                        .textStyle(RegularTextStyle())
                        .lineLimit(1)
                }
                
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
                        .offset(x: CGFloat(StartingProgress) * proxy.size.width*0.9 - proxy.size.width*0.45, y: 0)
                }.padding(.vertical)
                
            }
            .padding(proxy.size.width*0.05)
            .background{
                Rectangle()
                    .cornerRadius(5)
                    .foregroundColor(Constants.Colour.SecondaryLightGray)
            } .onReceive(timer) { _ in
                withAnimation {
                    if StartingProgress < (9*progressPercent/10) {
                        StartingProgress += (progressPercent/10)
                    }else{
                        StartingProgress = progressPercent
                    }
                }
            }
        }
        .frame(maxHeight: 100)
    }
}

#Preview {
    MapBottomSheetMetricLabelView(title: "PM2.5", value: "10 μg/m3")
}
