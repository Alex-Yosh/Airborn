//
//  LaunchView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-16.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var currentAppStatus: Constants.appNavigationControllers = .login

    var body: some View {
        VStack {
            switch currentAppStatus {
            case .login:
                LoginView()
            case .loading:
                Loading()
            case .restOfApp:
                MainTab()
            }
        }
        .onReceive(navigationManager.appStatus) { newStatus in
            currentAppStatus = newStatus
        }
    }
}

#Preview {
    LaunchView()
        .environmentObject(NavigationManager.shared)
}
