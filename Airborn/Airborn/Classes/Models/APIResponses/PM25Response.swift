//
//  PM25Response.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-02.
//

import Foundation

struct PM25DailyAverage: Codable {
    let average_pm25: Double
    let date: String
}

struct PM25Response: Codable {
    let pm25_daily_averages: [PM25DailyAverage]
    let sensor_id: String
    let time_range: String
}

