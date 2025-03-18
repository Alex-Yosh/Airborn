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
            Button(action: {
                loginManager.logout()
            }) {
                HStack {
                    Image(systemName: "arrow.right.square.fill")
                        .font(.title2)
                    Text("Logout")
                        .textStyle(LogOutTextStyle())
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.8))
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)

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
