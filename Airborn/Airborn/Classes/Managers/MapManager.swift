//
//  MapManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-03.
//

import Foundation
import Combine
import MapKit


class MapManager: ObservableObject {
    
    static var shared = MapManager()
    
    @Published var showSelectedSensor: Bool = false
    @Published var selectedSensor: SensorData? = nil
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.7783, longitude: -119.4179), // California
        span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
    )
    
    @Published var sensors = [SensorData(name: "name", lastUpdated: Date.now, lat: 43.873916, long: -79.243139, battery: 100.0, temp: 21.0, humidity: 23.0, PM25: 0.0, TVOC: 0.0, CO2: 0.0)]
    
    func ShowSensorSheet(sensor: SensorData) {
        selectedSensor = sensor
        showSelectedSensor = true
    }
    
    func HideSensorSheet() {
        selectedSensor = nil
        showSelectedSensor = false
    }
    
    
}
