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
    
    func getQuality(ofType: Constants.dataTypes) -> String {
        switch ofType {
        case .co2:
            switch(self.co2)
            {
            case 0...600.0:
                return "Excelent"
            case 600.1...800.0:
                return "Good"
            case 800.1...1000.0:
                return "Moderate"
            case 1000.1...1500.0:
                return "Unhealthy"
            case 1500.1...2000.0:
                return "Very Unhealthy"
            case let x where x > 2000.1:
                return "Hazardous"
                
            default:
                return "No Reading"
            }
        case .pm25:
            switch(self.pm25)
            {
            case 0...4.0:
                return "Excellent"
            case 4.1...9.0:
                return "Good"
            case 9.1...45.3:
                return "Moderate"
            case 45.4...125.4:
                return "Unhealthy"
            case 125.5...225.4:
                return "Very Unhealthy"
            case let x where x > 225.4:
                return "Hazardous"
                
            default:
                return "No Reading"
            }
            
        case .tvoc:
            switch(self.tvoc)
            {
            case 0...20.0:
                return "Very Unhealthy"
            case 20.0...40.0:
                return "Unhealthy"
            case 40.1...60.0:
                return "Moderate"
            case 60.1...80.0:
                return "Good"
            case 80.1...100:
                return "Excellent"
                
            default:
                return "No Reading"
            }
            
        default:
            return "No need"
        }
        
    }
    
}
