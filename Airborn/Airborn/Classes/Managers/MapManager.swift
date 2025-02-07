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
    @Published var selectedSensor: Sensor?
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.7783, longitude: -119.4179),
        span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
    )
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    @Published var sensors = [Sensor(id: UUID(), name: "test", latitude: 43.474823, longitude: -80.536141)]
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Get all Sensors
        DatabaseManager.shared.getAllSensors(){result in
            switch result {
            case .success(let sensors):
                self.sensors = sensors
            case .failure(let error):
                print("Error fetching sensor: \(error)")
            }
        }
        
    }
    
    func ShowSensorSheet(sensor: Sensor) {
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
