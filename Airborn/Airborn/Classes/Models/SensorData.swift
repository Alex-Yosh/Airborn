//
//  SensorData.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-26.
//

import Foundation

struct SensorData: Hashable, Identifiable{
    let id = UUID() // Always unique on map
    
    var name: String
    var lastUpdated: Date
    
    //location
    var lat: Double
    var long: Double
    
    //maybe
    var battery: Double
    
    //data
    var temp: Double
    var humidity: Double
    var PM25: Double
    var TVOC: Double
    var CO2: Double
}
