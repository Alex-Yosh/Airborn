//
//  Constants.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import Foundation
import SwiftUI

struct Constants {
    enum appNavigationControllers {
        case login
        case loading
        case restOfApp
    }
    
    enum mainTabType {
        case home
        case data
        case map
    }
    
    enum dataTypes: String {
        case temperature = "Temperature"
        case humidity = "Humidity"
        case pm25 = "PM2.5"
        case tvoc = "TVOC"
        case co2 = "CO2"
        
        // Computed property to map data type to a metric
        var metric: String {
            switch self {
            case .temperature:
                return "°C"
            case .humidity:
                return "RH"
            case .pm25:
                return "µg/m³"
            case .tvoc:
                return "ppb"
            case .co2:
                return "ppm"
            }
        }
        
        // Description
        var description: String {
            switch self {
            case .pm25:
                return "Tiny airborne particles (≤2.5 micrometers) that can penetrate deep into the lungs and affect respiratory health. Common indoor sources include cooking, burning candles, smoking, and dust buildup"
            case .tvoc:
                return "A group of airborne chemicals that can lower indoor air quality and cause irritation or long-term health effects. Common indoor sources include cleaning products, air fresheners, paints, furniture, and cooking fumes."
            case .co2:
                return "A naturally occurring gas that can accumulate in poorly ventilated spaces, leading to discomfort and reduced cognitive function."
                
            default:
                return ""
            }
        }
        
        // Standards
        var standards: String {
            switch self {
            case .pm25:
                return "The WHO Air Quality Guidelines recommend keeping PM2.5 levels below 5 µg/m³ (annual average) and below 15 µg/m³ (24-hour average) to minimize health risks."
            case .co2:
                return "The WHO recommends keeping CO2 levels below 1000 ppm indoors to ensure proper ventilation. Levels above 1500 ppm may indicate poor air circulation."
                
            default:
                return ""
            }
        }
    }
    
    enum apiAveragesEndpoint: String {
        case pm25 = "pm25"
        case tvoc = "tvoc"
        case co2 = "co2"
    }
    
    enum dataFilterType: String, CaseIterable  {
        case last7Days = "Last Week"
        case lastDay = "Today"
    }
    
    struct Colour {
        static var PrimaryBlue = Color(hex: "A7D3E0")
        static var PrimaryGreen = Color(hex: "A8D8B9")
        static var SecondaryWhite = Color(hex: "FFFFFF")
        static var SecondaryLightGray = Color(hex: "F5F5F5")
        static var AccentYellow = Color(hex: "FFEB3B")
        static var AccentOrange = Color(hex: "FF9800")
        
        static var DarkGray = Color(hex: "9D9D9D")
        
        static var ScaleRed = Color(hex: "ED4D4D")
        static var ScaleDarkOrange = Color(hex: "E59148")
        static var ScaleLightOrange = Color(hex: "EFBF39")
        static var ScaleYellow = Color(hex: "EEED56")
        static var ScaleGreen = Color(hex: "32E1A0")
        
        static var HomeScaleStrongerGreen = Color(hex: "4DE680")
        static var HomeScaleGreenishYellow = Color(hex: "B3FF99")
        static var HomeScaleStrongYellow = Color(hex: "FFE64D")
        static var HomeScaleDarkerOrange = Color(hex: "FFB333")
        static var HomeScaleStrongRed = Color(hex: "E6331A")
        
        static var GrayishWhite = Color(hex: "F9F9F9")
        
        static var ScaleBlue = Color(hex: "007BFF")
    }
    
}
