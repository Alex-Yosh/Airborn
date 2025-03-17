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
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "America/New_York")
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
    
    func getQualityText(ofType: Constants.dataTypes) -> String {
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
    
    func getQualityPercentage(ofType: Constants.dataTypes) -> Float {
        func interpolate(value: Double, lowerBound: Double, upperBound: Double, minPercentage: Double, maxPercentage: Double, invert: Bool = false) -> Float {
            guard upperBound > lowerBound else { return Float(minPercentage) } // Avoid division by zero
            
            let fraction = (value - lowerBound) / (upperBound - lowerBound) // Normalize value within range
            let interpolatedValue = minPercentage + fraction * (maxPercentage - minPercentage) // Scale to range
            
            return invert ? Float(maxPercentage - (interpolatedValue - minPercentage)) : Float(interpolatedValue) // Invert if needed
        }
        
        switch ofType {
        case .co2:
            switch self.co2 {
            case 0...600.0:
                return interpolate(value: self.co2, lowerBound: 0, upperBound: 600, minPercentage: 0.81, maxPercentage: 1.0, invert: true)
            case 600.1...800.0:
                return interpolate(value: self.co2, lowerBound: 600.1, upperBound: 800, minPercentage: 0.61, maxPercentage: 0.8, invert: true)
            case 800.1...1000.0:
                return interpolate(value: self.co2, lowerBound: 800.1, upperBound: 1000, minPercentage: 0.41, maxPercentage: 0.6, invert: true)
            case 1000.1...1500.0:
                return interpolate(value: self.co2, lowerBound: 1000.1, upperBound: 1500, minPercentage: 0.21, maxPercentage: 0.4, invert: true)
            case 1500.1...2000.0:
                return interpolate(value: self.co2, lowerBound: 1500.1, upperBound: 2000, minPercentage: 0.01, maxPercentage: 0.2, invert: true)
            default:
                return 0.0 // Hazardous (CO2 > 2000)
            }
            
        case .pm25:
            switch self.pm25 {
            case 0...4.0:
                return interpolate(value: self.pm25, lowerBound: 0, upperBound: 4, minPercentage: 0.81, maxPercentage: 1.0, invert: true)
            case 4.1...9.0:
                return interpolate(value: self.pm25, lowerBound: 4.1, upperBound: 9, minPercentage: 0.61, maxPercentage: 0.8, invert: true)
            case 9.1...45.3:
                return interpolate(value: self.pm25, lowerBound: 9.1, upperBound: 45.3, minPercentage: 0.41, maxPercentage: 0.6, invert: true)
            case 45.4...125.4:
                return interpolate(value: self.pm25, lowerBound: 45.4, upperBound: 125.4, minPercentage: 0.21, maxPercentage: 0.4, invert: true)
            case 125.5...225.4:
                return interpolate(value: self.pm25, lowerBound: 125.5, upperBound: 225.4, minPercentage: 0.01, maxPercentage: 0.2, invert: true)
            default:
                return 0.0 // Hazardous (PM2.5 > 225.4)
            }
            
            
        case .tvoc:
            return Float(self.tvoc/100.0)
            
        default:
            return -1.0 // No need
        }
    }
}
extension SensorData {
    func calculateAQI() -> Int {
        // AQI calculation for PM2.5 (EPA Standard in μg/m³)
        let pm25AQI = getAQI(value: pm25, breakpoints: [
            (0.0, 12.0, 0, 50),
            (12.1, 35.4, 51, 100),
            (35.5, 55.4, 101, 150),
            (55.5, 150.4, 151, 200),
            (150.5, 250.4, 201, 300),
            (250.5, 500.4, 301, 500)
        ])
        //
        // AQI calculation for CO2 (ppm, based on health impact)
        //        let co2AQI = getAQI(value: co2, breakpoints: [
        //            (0, 600, 0, 50),
        //            (601, 800, 51, 100),
        //            (801, 1000, 101, 150),
        //            (1001, 1500, 151, 200),
        //            (1501, 2000, 201, 300),
        //            (2001, 5000, 301, 500)
        //        ])
        //
        // **Invert TVOC** because 100 = good, 0 = bad
        let invertedTVOC = 100 - tvoc // Now 100 = worst, 0 = best
        let tvocAQI = getAQI(value: invertedTVOC, breakpoints: [
            (0, 10, 0, 50),
            (11, 30, 51, 100),
            (31, 50, 101, 150),
            (51, 70, 151, 200),
            (71, 90, 201, 300),
            (91, 100, 301, 500)
        ])
        
        //  Return the highest AQI (worst air quality factor)
        //        return max(pm25AQI, co2AQI, tvocAQI)
        return max(pm25AQI, tvocAQI)
    }
    
    /// Helper function to calculate AQI based on breakpoints
    private func getAQI(value: Double, breakpoints: [(Double, Double, Int, Int)]) -> Int {
        for (low, high, aqiLow, aqiHigh) in breakpoints {
            if value >= low && value <= high {
                return interpolateAQI(value: value, low: low, high: high, aqiLow: aqiLow, aqiHigh: aqiHigh)
            }
        }
        return 500 // If value exceeds max, return max AQI
    }
    
    /// **Fixed** Linear interpolation for AQI calculation
    private func interpolateAQI(value: Double, low: Double, high: Double, aqiLow: Int, aqiHigh: Int) -> Int {
        if high == low { return aqiLow } // Prevent division by zero
        let fraction = (value - low) / (high - low)
        let interpolatedAQI = fraction * Double(aqiHigh - aqiLow) + Double(aqiLow)
        return min(500, max(0, Int(interpolatedAQI))) // Ensure AQI stays within 0-500
    }
    
    func calculateAQIPercentage() -> Double {
        let aqi = Double(calculateAQI()) // Get the AQI value (0 - 500)
        
        // **Non-Linear Scaling: Higher AQI increases percentage more aggressively**
        let scaledPercentage = pow(aqi / 500.0, 1.2) // Exponent 1.2 makes higher values worse faster
        
        return min(1.0, scaledPercentage) // Ensure it never exceeds 1.0
    }
    
    
}
