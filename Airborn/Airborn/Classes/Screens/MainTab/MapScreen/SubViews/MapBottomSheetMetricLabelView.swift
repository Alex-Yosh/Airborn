//
//  MapBottomSheetMetricLabelView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-04.
//

import SwiftUI

struct MapBottomSheetMetricLabelView: View {
    
    var title: String
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var progressPercent: Float = 1
    
    var body: some View {
            VStack{
                HStack(){
                    Text(title)
                        .textStyle(SubHeadingTextStyle())
                        .lineLimit(1)
                    Spacer()
                }.padding([.horizontal, .top])
                ScaleBarView(progressPercent: progressPercent)
            }.background{
                Rectangle()
                    .cornerRadius(5)
                .foregroundColor(Constants.Colour.SecondaryLightGray)}
        
                
    }
}

#Preview {
    MapBottomSheetMetricLabelView(title: "PM2.5")
}
