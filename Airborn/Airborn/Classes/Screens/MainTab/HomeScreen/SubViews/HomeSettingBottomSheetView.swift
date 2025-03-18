//
//  HomeSettingBottomSheetView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-18.
//

import SwiftUI

struct HomeSettingBottomSheetView: View {
    @EnvironmentObject var loginManager: LoginManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .textStyle(SubHeadingTextStyle())

            Divider()

            // Logout Button
            LongButtonView(title: "Logout", systemImage: "arrow.right.square.fill", backgroundColor: Color.red, action: {
                loginManager.logout()
            })

            Spacer()
        }
        .padding()
        .interactiveDismissDisabled(false) // Allow swipe to dismiss
    }
}
#Preview {
    HomeSettingBottomSheetView()
        .environmentObject(LoginManager.shared)
}
