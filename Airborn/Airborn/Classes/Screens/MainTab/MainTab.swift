//
//  MainTab.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct MainTab: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    init() {
        //        let appearance = UITabBarAppearance()
        //        appearance.shadowColor = .white
        //        appearance.shadowImage = UIImage(named: "tab-shadow")?.withRenderingMode(.alwaysTemplate)
        //
        //        UITabBar.appearance().scrollEdgeAppearance = appearance
        
    }
    
    var body: some View {
        Group {
            TabView (selection: $navigationManager.selectedHomeTab) {
                
                NavigationStack {
                    MapView()
                }
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(Constants.mainTabType.map)
                
                
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Constants.mainTabType.home)
                
                DataView()
                    .tabItem {
                        Label("Data", systemImage: "chart.bar")
                    }
                    .tag(Constants.mainTabType.data)
                
            }
        }
    }
}

#Preview {
    MainTab()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MapManager.shared)
}
