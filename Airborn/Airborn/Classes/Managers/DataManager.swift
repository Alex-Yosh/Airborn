//
//  DataManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-25.
//

import Foundation

class DataManager: ObservableObject {
    
    static var shared = DataManager()
    
    @Published var selectedDataType: Constants.dataTypes?
    @Published var data: [SensorData] = [SensorData(id: UUID(), sensorId: UUID(), temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, date: Date()),
                  SensorData(id: UUID(), sensorId: UUID(), temperature: 21.0, humidity: 48, pm25: 15, tvoc: 1.2, co2: 420, date: Date().addingTimeInterval(-480000)),
                  SensorData(id: UUID(), sensorId: UUID(), temperature: 22.3, humidity: 46, pm25: 8, tvoc: 1.1, co2: 410, date: Date().addingTimeInterval(-320000))]
    @Published var filterType: Constants.dataFilterType = .last7Days
    
}
