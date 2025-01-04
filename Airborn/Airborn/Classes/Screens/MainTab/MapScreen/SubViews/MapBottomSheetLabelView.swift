//
//  MapBottomSheetLabelView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-04.
//

import SwiftUI

struct MapBottomSheetLabelView: View {
    
    var image: String
    var text: String
    
    var body: some View {
        HStack(){
            Image(systemName: image)
                .imageScale(.large)
            Spacer()
            Text(text)
                .textStyle(SubHeadingTextStyle())
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background{
            Rectangle()
                .cornerRadius(5)
                .foregroundColor(Constants.Colour.SecondaryLightGray)
        }
    }
}

#Preview {
    MapBottomSheetLabelView(image: "thermometer.high", text: "21°C")
}
