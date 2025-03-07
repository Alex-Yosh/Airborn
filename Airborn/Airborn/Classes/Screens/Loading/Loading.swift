//
//  Loading.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct Loading: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mapManager: MapManager
    @EnvironmentObject var databaseManager: DatabaseManager
    
    @State private var isDataFetched = false
    @State private var isLocationFetched = false
    @State private var hasCheckedPermissions = false
    @State private var isLoadingStarted = false
    
    var body: some View {
        VStack {
            if !hasCheckedPermissions {
                ProgressView("Checking Permissions...")
                    .onAppear {
                        checkPermissions()
                    }
            } else if !mapManager.isLocationPermissionGranted {
                VStack {
                    Text("This app requires location permissions to continue.")
                        .font(.headline)
                        .padding()
                }
            } else {
                VStack {
                    Text("Loading...")
                        .font(.title)
                        .padding()
                    ProgressView()
                }
                .onAppear {
                    if !isLoadingStarted {
                        isLoadingStarted = true
                        startLoadingProcess()
                    }
                }
            }
        }
    }
    
    private func checkPermissions() {
        DispatchQueue.main.async {
            mapManager.checkAuthorization()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                hasCheckedPermissions = true
                if !mapManager.isLocationPermissionGranted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        checkPermissions() // Recheck in 1 second if not granted
                    }
                }
            }
        }
    }
    
    private func startLoadingProcess() {
        let group = DispatchGroup()
        
        
        // Ensure sensors are fetched first
        mapManager.fetchSensors()
        
        // Task 1: Wait until `nearestSensor` is set before fetching sensor data
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let _ = mapManager.nearestSensor {
                databaseManager.fetchLatestSensorData { latestData in
                    DispatchQueue.main.async {
                        if latestData != nil {
                            self.isDataFetched = true
                        }
                        group.leave()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    startLoadingProcess()
                }
            }
        }
        
        // Task 2: Ensure location permission is granted and nearestSensor is available
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if mapManager.isLocationPermissionGranted && mapManager.nearestSensor != nil {
                self.isLocationFetched = true
            }
            group.leave()
        }
        
        // Task 3: Minimum 2-second delay
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            group.leave()
        }
        
        // Notify when all tasks are complete
        group.notify(queue: .main) {
            if self.isDataFetched && self.isLocationFetched {
                navigationManager.appStatus.value = .restOfApp
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    startLoadingProcess()
                }
            }
        }
    }
}

#Preview {
    Loading()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MapManager.shared)
        .environmentObject(DatabaseManager.shared)
}
