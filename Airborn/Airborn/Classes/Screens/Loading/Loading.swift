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
                        print("Checking permissions...")
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
                        print("Starting loading process...")
                        isLoadingStarted = true
                        startLoadingProcess()
                    }
                }
            }
        }
    }
    
    private func checkPermissions() {
        DispatchQueue.main.async {
            print("Requesting location permission...")
            mapManager.checkAuthorization()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                hasCheckedPermissions = true
                print("Location permission granted: \(mapManager.isLocationPermissionGranted)")
                
                if !mapManager.isLocationPermissionGranted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        print("Retrying location permission check...")
                        checkPermissions() // Recheck in 1 second if not granted
                    }
                }
            }
        }
    }
    
    private func startLoadingProcess() {
        let group = DispatchGroup()
        
        print("Fetching sensors...")
        mapManager.fetchSensors()
        
        // Task 1: Wait until `nearestSensor` is set before fetching sensor data
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let nearestSensor = mapManager.nearestSensor {
                print("Nearest sensor found: \(nearestSensor.id)")
                
                databaseManager.fetchLatestSensorData { latestData in
                    DispatchQueue.main.async {
                        if let latestData = latestData {
                            self.isDataFetched = true
                            print("Latest sensor data fetched successfully.")
                        } else {
                            print("Failed to fetch latest sensor data.")
                        }
                        group.leave()
                    }
                }
            } else {
                print("Nearest sensor not found, retrying...")
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
                print("Location data and nearest sensor available.")
            } else {
                print("Location permission or nearest sensor still unavailable.")
            }
            group.leave()
        }
        
        // Task 3: Minimum 2-second delay
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Minimum loading time reached.")
            group.leave()
        }
        
        // Notify when all tasks are complete
        group.notify(queue: .main) {
            print("Loading process completed. Data fetched: \(self.isDataFetched), Location fetched: \(self.isLocationFetched)")
            
            if self.isDataFetched && self.isLocationFetched {
                print("Navigating to restOfApp...")
                navigationManager.appStatus.value = .restOfApp
            } else {
                print("Retrying loading process in 1 second...")
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
