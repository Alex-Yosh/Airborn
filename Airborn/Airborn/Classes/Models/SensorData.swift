//
//  SensorData.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-26.
//

import Foundation

struct SensorData: Codable {
    let temperature: Double
    let humidity: Double
    let pm25: Double
    let tvoc: Double
    let co2: Double
    let timestamp: Date
    
    private enum CodingKeys: String, CodingKey {
        case temperature, humidity, pm25, tvoc, co2, timestamp
    }
    
    /// Custom Decoder for Handling Non-Standard Timestamp
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

extension SensorData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.temperature = try container.decode(Double.self, forKey: .temperature)
        self.humidity = try container.decode(Double.self, forKey: .humidity)
        self.pm25 = try container.decode(Double.self, forKey: .pm25)
        self.tvoc = try container.decode(Double.self, forKey: .tvoc)
        self.co2 = try container.decode(Double.self, forKey: .co2)
        
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        if let date = SensorData.dateFormatter.date(from: timestampString) {
            self.timestamp = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .timestamp, in: container, debugDescription: "Invalid date format")
        }
    }
    
    func getValue(ofType: Constants.dataTypes) -> Double {
        switch ofType {
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
