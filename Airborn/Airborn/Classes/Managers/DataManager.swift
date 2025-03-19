//
//  DataManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-25.
//

import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    
    static var shared = DataManager()
    
    @Published var selectedDataType: Constants.dataTypes?
    @Published var filterType: Constants.dataFilterType = .last7Days
    
    @Published var latestSensorData: SensorData?
    
    private var timer: AnyCancellable?
    
    init() {
        startPolling()
    }
    
    /// Starts polling for new sensor data every 10 seconds
    private func startPolling() {
        timer = Timer.publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                DatabaseManager.shared.fetchLatestNearestSensorData{ latestDataResponse in
                    self.latestSensorData = latestDataResponse?.latest_reading
                }
            }
    }
    
    /// Stops the polling
    func stopPolling() {
        timer?.cancel()
        timer = nil
    }
    
    
    /// Get last 7-day average from user exposure data
    func getLast7DayAverage(type: Constants.dataTypes, completion: @escaping ([Double]) -> Void) {
        guard let userId = LoginManager.shared.uuid else {
            completion([])
            return
        }
        
        var apitype = Constants.apiAveragesEndpoint.co2
        switch(type){
        case .co2:
            apitype = Constants.apiAveragesEndpoint.co2
        case .pm25:
            apitype = Constants.apiAveragesEndpoint.pm25
        case .tvoc:
            apitype = Constants.apiAveragesEndpoint.tvoc
        default:
            completion([])
            return
        }
        
        print(apitype.rawValue)
        DatabaseManager.shared.getUserWeekAverages(type: apitype) { (result: [Double]) in
            print(result)
            completion(result)
        }
    }
}
