//
//  NoInternetView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-18.
//

import SwiftUI

struct NoInternetView: View {
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
            
            VStack(spacing: 8){
                Text("No Internet Connection")
                    .textStyle(NoInternetTitleTextStyle())
                
                Text("Check your connection and try again.")
                    .textStyle(NoInternetSubTitleTextStyle())
            }
            
            LongButtonView(title: "Retry", systemImage: "arrow.clockwise", backgroundColor: Color.blue, action: {
                networkManager.checkConnection()
            })
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .transition(.opacity)
    }
}


#Preview {
    NoInternetView()
        .environmentObject(NetworkManager.shared)
}
