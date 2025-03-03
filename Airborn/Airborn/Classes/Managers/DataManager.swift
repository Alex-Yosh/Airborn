//
//  DataManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-25.
//

import Foundation
import SwiftUI

class DataManager: ObservableObject {
    
    static var shared = DataManager()
    
    @Published var selectedDataType: Constants.dataTypes?
    @Published var data: [SensorData] = [SensorData(id: UUID(), sensorId: UUID(), temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, date: Date()),
                                         SensorData(id: UUID(), sensorId: UUID(), temperature: 21.0, humidity: 48, pm25: 15, tvoc: 1.2, co2: 420, date: Date().addingTimeInterval(-480000)),
                                         SensorData(id: UUID(), sensorId: UUID(), temperature: 22.3, humidity: 46, pm25: 8, tvoc: 1.1, co2: 410, date: Date().addingTimeInterval(-320000))]
    @Published var filterType: Constants.dataFilterType = .last7Days
    
    @Published var closestSensor: Sensor? = Sensor(id: UUID(uuidString: "1dfab928-8a67-41f2-81cf-118e7c1fa7a4")!, name: "hi", latitude: 0, longitude: 0)
    
    func getLast7DayAverage(type: Constants.dataTypes, completion: @escaping ([Double]) -> Void) {
        if let closestSensor = closestSensor {
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
