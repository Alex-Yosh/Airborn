//
//  MapManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-03.
//

import Foundation
import Combine
import MapKit
import CoreLocation


class MapManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static var shared = MapManager()
    
    private let locationManager = CLLocationManager()
    
    @Published var showSelectedSensor: Bool = false
    @Published var selectedSensor: SensorData? = nil
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.7783, longitude: -119.4179), // California
        span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
    )
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    @Published var sensors = [SensorData(name: "name", lastUpdated: Date.now, lat: 43.474823, long: -80.536141, battery: 100.0, temp: 21.0, humidity: 23.0, PM25: 0.0, TVOC: 0.0, CO2: 0.0)]
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func ShowSensorSheet(sensor: SensorData) {
        selectedSensor = sensor
        showSelectedSensor = true
    }
    
    func HideSensorSheet() {
        selectedSensor = nil
        showSelectedSensor = false
    }
    
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied or restricted")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("Unknown location authorization status")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
