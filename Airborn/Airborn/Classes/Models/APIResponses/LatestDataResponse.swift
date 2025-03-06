//
//  LatestDataResponse.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-05.
//

import Foundation

struct LatestDataResponse: Codable {
    let latest_reading: SensorData
    let sensor_id: UUID
}
