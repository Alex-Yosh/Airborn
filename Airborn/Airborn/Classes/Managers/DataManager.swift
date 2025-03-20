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
    @Published var filterType: Constants.dataFilterType = .lastDay
    
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
    
    
    /// Get User average from user exposure data
    func getUserAverages(type: Constants.dataTypes, completion: @escaping ([Double]) -> Void) {
        guard LoginManager.shared.uuid != nil else {
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
        
        switch(filterType){
        case .lastDay:
            DatabaseManager.shared.getUserDayAverages(type: apitype) { (result: [Double]) in
                completion(result)
            }
        case .last7Days:
            DatabaseManager.shared.getUserWeekAverages(type: apitype) { (result: [Double]) in
                completion(result)
            }
        }
    }
}
