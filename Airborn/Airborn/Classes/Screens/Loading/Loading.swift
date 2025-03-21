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
    @EnvironmentObject var dataManager: DataManager
    
    @State private var isDataFetched = false
    @State private var isLocationFetched = false
    @State private var hasCheckedPermissions = false
    @State private var isLoadingStarted = false
    
    @State private var opacity: Double = 1.0
    @State private var animateFade = false
    @State private var isLoading = true
    @State private var text = "A"
    
    var body: some View {
        VStack {
            if !hasCheckedPermissions {
                Text(text)
                    .textStyle(LoadingTextStyle())
                    .foregroundColor(.primary)
                    .opacity(opacity)
                    .animation(.easeInOut(duration: 0.1), value: text)
                    .onAppear {
                        startTextAnimation()
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
                Text("AIRBORNE")
                    .textStyle(LoadingTextStyle())
                    .opacity(opacity)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: opacity)
                    .onAppear {
                        startLoadingAnimation()
                        startLoadingProcess()
                    }
            }
        }
    }
    
    private func startLoadingAnimation() {
        opacity = 0.2
    }
    
    private func startTextAnimation() {
        // Step 1: Delay for a moment with just "A"
        let fullText = "AIRBORNE"

        // Step 1: Show "A" for 0.6s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            for i in 2...fullText.count {
                let delay = 0.6 + Double(i - 1) * 0.1
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    text = String(fullText.prefix(i))
                }
            }
        }
    }
    
    private func checkPermissions() {
        DispatchQueue.main.async {
            print("Requesting location permission...")
            mapManager.checkAuthorization()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                
                databaseManager.fetchLatestNearestSensorData { latestDataResponse in
                    DispatchQueue.main.async {
                        if (latestDataResponse?.latest_reading) != nil {
                            self.isDataFetched = true
                            dataManager.immediatePoll()
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
        .environmentObject(DataManager.shared)

}
