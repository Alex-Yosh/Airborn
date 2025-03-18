//
//  AirbornApp.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-13.
//

import SwiftUI

@main
struct AirbornApp: App {

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(DatabaseManager.shared)
                .environmentObject(NavigationManager.shared)
                .environmentObject(MapManager.shared)
                .environmentObject(DataManager.shared)
                .environmentObject(LoginManager.shared)
                .environmentObject(NetworkManager.shared)
        }
    }
}
