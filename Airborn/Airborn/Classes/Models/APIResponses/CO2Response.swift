//
//  CO2Response.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-02.
//

import Foundation

struct CO2DailyAverage: Codable {
    let average_co2: Double
    let date: String
}

struct CO2Response: Codable {
    let co2_daily_averages: [CO2DailyAverage]
    let sensor_id: String
    let time_range: String
}
