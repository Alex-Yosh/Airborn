//
//  SensorData.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-26.
//

import Foundation

<<<<<<< HEAD
struct SensorData: Codable {
=======
struct SensorData: Codable, Identifiable {
>>>>>>> 37f54b8 (fixed a bit)
    let sensorId: UUID
    let temperature: Double
    let humidity: Double
    let pm25: Double
    let tvoc: Double
    let co2: Double
    let date: Date?
}
