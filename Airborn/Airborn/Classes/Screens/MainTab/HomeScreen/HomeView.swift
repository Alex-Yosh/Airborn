//
//  HomeView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack{
            //top gradiant
            LinearGradient(colors: [Constants.Colour.PrimaryBlue, .white], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack(spacing: 32){
                HomeTopTextView()
                Spacer()
                //TODO: remove constant and add real valaues
                HomeScaleView(progressPercent: 0.875)
                Spacer()
            }
            
        }
    }
}

#Preview {
    HomeView()
}
