//
//  SensorData.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-26.
//

import Foundation

struct SensorData: Codable, Identifiable {
    let id: UUID
    
    let sensorId: UUID
    let temperature: Double
    let humidity: Double
    let pm25: Double
    let tvoc: Double
    let co2: Double
    let date: Date?
    
    func getValue(ofType:Constants.dataTypes) -> Double{
        switch(ofType){
        case .co2:
            return self.co2
            
        case .humidity:
            return self.humidity
            
        case .pm25:
            return self.pm25
            
        case .temperature:
            return self.temperature
            
        case .tvoc:
            return self.tvoc
        }
    }
}
