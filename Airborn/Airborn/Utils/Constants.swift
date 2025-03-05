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
    }
    
    enum apiAveragesEndpoint: String {
        case pm25 = "pm25"
        case tvoc = "tvoc"
        case co2 = "co2"
    }
    
    enum dataFilterType {
        case last7Days
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
        
        
        static var ScaleBlue = Color(hex: "007BFF")
        
    }
    
}
