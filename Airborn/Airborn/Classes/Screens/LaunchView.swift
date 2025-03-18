//
//  LaunchView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-16.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var networkManager: NetworkManager

    @State private var currentAppStatus: Constants.appNavigationControllers = .login

    var body: some View {
        ZStack{
            VStack {
                switch currentAppStatus {
                case .login:
                    Login()
                case .loading:
                    Loading()
                case .restOfApp:
                    MainTab()
                }
            }
            .onReceive(navigationManager.appStatus) { newStatus in
                currentAppStatus = newStatus
            }
            
            //overlay if no internet
            if !networkManager.isConnected {
                NoInternetView()
            }
        }
    }
}

#Preview {
    LaunchView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(LoginManager.shared)
        .environmentObject(NetworkManager.shared)
}
