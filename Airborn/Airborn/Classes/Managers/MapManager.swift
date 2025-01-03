//
//  MapManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-03.
//

import Foundation


class MapManager: ObservableObject {
    
    static var shared = MapManager()
    
    @Published var showSelectedSensor: Bool = false
    @Published var selectedSensor: SensorData? = nil
    
    func ShowSensorSheet(sensor: SensorData) {
        selectedSensor = sensor
        showSelectedSensor = true
    }
    
    func HideSensorSheet() {
        selectedSensor = nil
        showSelectedSensor = false
    }
    
    
}
