//
//  HomeSettingButtonView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-18.
//

import SwiftUI

struct HomeSettingButtonView: View {
    @EnvironmentObject var loginManager: LoginManager
    @Binding var showSettingsSheet: Bool
    
    var body: some View {
        Button(action: {
            showSettingsSheet.toggle()
        }) {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundColor(.primary)
                .padding(8)
                .clipShape(Circle())
        }.padding()
    }
}


#Preview {
    HomeSettingButtonView(showSettingsSheet: .constant(false))
        .environmentObject(LoginManager.shared)
}
