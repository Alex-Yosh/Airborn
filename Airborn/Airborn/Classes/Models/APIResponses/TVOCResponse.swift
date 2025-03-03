//
//  TVOCResponse.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-02.
//

import Foundation

struct TVOCDailyAverage: Codable {
    let average_tvoc: Double
    let date: String
}

struct TVOCResponse: Codable {
    let tvoc_daily_averages: [TVOCDailyAverage]
    let sensor_id: String
    let time_range: String
}
