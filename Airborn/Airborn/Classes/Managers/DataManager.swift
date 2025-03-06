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
                DatabaseManager.shared.fetchLatestSensorData{ latestData in
                    self.latestSensorData = latestData
                }
            }
    }
    
    /// Stops the polling
    func stopPolling() {
        timer?.cancel()
        timer = nil
    }


    /// Fetches 7-day historical data for the closest sensor
    func getLast7DayAverage(type: Constants.dataTypes, completion: @escaping ([Double]) -> Void) {
        if let closestSensor = MapManager.shared.nearestSensor {
            switch type {
            case .co2:
                DatabaseManager.shared.getCO2DailyAverages(sensorId: closestSensor.id) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let co2Response):
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let sortedAverages = co2Response.co2_daily_averages
                                .compactMap { item -> (date: Date, value: Double)? in
                                    guard let date = dateFormatter.date(from: item.date) else { return nil }
                                    return (date, item.average_co2)
                                }
                                .sorted { $0.date < $1.date }
                                .map { $0.value }
                            
                            completion(sortedAverages) // Return data via completion
                        case .failure(_):
                            completion([]) // Return empty array on failure
                        }
                    }
                }

            case .pm25:
                DatabaseManager.shared.getPM25DailyAverages(sensorId: closestSensor.id) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let pm25Response):
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let sortedAverages = pm25Response.pm25_daily_averages
                                .compactMap { item -> (date: Date, value: Double)? in
                                    guard let date = dateFormatter.date(from: item.date) else { return nil }
                                    return (date, item.average_pm25)
                                }
                                .sorted { $0.date < $1.date }
                                .map { $0.value }
                            
                            completion(sortedAverages)
                        case .failure(_):
                            completion([])
                        }
                    }
                }

            case .tvoc:
                DatabaseManager.shared.getTVOCDailyAverages(sensorId: closestSensor.id) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let tvocResponse):
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let sortedAverages = tvocResponse.tvoc_daily_averages
                                .compactMap { item -> (date: Date, value: Double)? in
                                    guard let date = dateFormatter.date(from: item.date) else { return nil }
                                    return (date, item.average_tvoc)
                                }
                                .sorted { $0.date < $1.date }
                                .map { $0.value }
                            
                            completion(sortedAverages)
                        case .failure(_):
                            completion([])
                        }
                    }
                }

            default:
                completion([])
            }
        } else {
            completion([])
        }
    }
}
