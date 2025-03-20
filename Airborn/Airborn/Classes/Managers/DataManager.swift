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

    @Published var averagepm25Percent: Float = 0.0
    @Published var averagetvocPercent: Float = 0.0
    @Published var averageco2Percent: Float = 0.0
    @Published var meanpm25: Double = 0.0
    @Published var meantvoc: Double = 0.0
    @Published var meanco2: Double = 0.0

    
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
            DispatchQueue.main.async {
                completion([])
            }
            return
        }

        var apitype = Constants.apiAveragesEndpoint.co2
        switch type {
        case .co2: apitype = .co2
        case .pm25: apitype = .pm25
        case .tvoc: apitype = .tvoc
        default:
            DispatchQueue.main.async {
                completion([])
            }
            return
        }

        switch filterType {
        case .lastDay:
            DatabaseManager.shared.getUserDayAverages(type: apitype) { result in
                self.updateAverages(type: apitype, results: result)

                DispatchQueue.main.async {
                    completion(result)
                }
            }
        case .last7Days:
            DatabaseManager.shared.getUserWeekAverages(type: apitype) { result in
                
                self.updateAverages(type: apitype, results: result)

                DispatchQueue.main.async {                   
                    completion(result)
                }
            }
        }
    }

    
    func updateAverages(type: Constants.apiAveragesEndpoint, results: [Double]) {
        let mean = results.isEmpty ? 0 : results.reduce(0, +) / Double(results.count)
        let data = SensorData(temperature: 0, humidity: 0, pm25: mean, tvoc: mean, co2: mean, timestamp: Date.now)

        DispatchQueue.main.async { 
            switch type {
            case .co2:
                self.meanco2 = mean
                self.averageco2Percent = data.getQualityPercentage(ofType: .co2)
            case .pm25:
                self.meanpm25 = mean
                self.averagepm25Percent = data.getQualityPercentage(ofType: .pm25)
            case .tvoc:
                self.meantvoc = mean
                self.averagetvocPercent = data.getQualityPercentage(ofType: .tvoc)
            }
        }
    }
    
    func getMean(type: Constants.dataTypes) -> Double
    {
        switch(type){
        case .co2:
            return meanco2
        case .pm25:
            return meanpm25
        case .tvoc:
            return meantvoc
        default:
            return 0
        }
    }
}
