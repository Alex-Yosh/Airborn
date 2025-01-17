//
//  Sensor.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-16.
//

import Foundation

struct Sensor: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
}
