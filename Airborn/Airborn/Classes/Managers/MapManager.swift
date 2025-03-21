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
import SwiftUI

class MapManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static var shared = MapManager()
    
    private let locationManager = CLLocationManager()
    
    @Published var showSelectedSensor: Bool = false
    @Published var selectedSensor: Sensor?
    @Published var selectedSensorData: SensorData?
    @Published var isLocationPermissionGranted: Bool = false
    @Published var sensorAddress: String?
    
    @Published var nearestSensor: Sensor?
    
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.7783, longitude: -119.4179),
        span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
    )
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    @Published var sensors: [Sensor] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorization()
    }
    
    func fetchSensors(){
        // Fetch all sensors from database
        DatabaseManager.shared.getAllSensors { result in
            switch result {
            case .success(let sensors):
                DispatchQueue.main.async {
                    self.sensors = sensors.filter { sensor in
                        (sensor.latitude >= -90.0 && sensor.latitude <= 90.0) &&
                        (sensor.longitude >= -180.0 && sensor.longitude <= 180.0)
                    }
                    
                    self.findNearestSensor()
                }
            case .failure(let error):
                print("Error fetching sensor: \(error)")
            }
        }
    }
    
    func ShowSensorSheet(sensor: Sensor) {
        //get data
        DatabaseManager.shared.fetchLatestSelectedSensorData(selectedSensor: sensor){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sensorData):
                    self.selectedSensorData = sensorData
                case .failure(_):
                    return
                }
            }
        }
        
        selectedSensor = sensor
        showSelectedSensor = true
    }
    
    
    func centerMapOnSensor(sensor: Sensor) {
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let adjustedLatitude = sensor.latitude - (regionSpan.latitudeDelta / 3) // Moves the marker up slightly

        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: adjustedLatitude, longitude: sensor.longitude),
            span: regionSpan
        )
    }
    
    func HideSensorSheet() {
        selectedSensor = nil
        selectedSensorData = nil
        showSelectedSensor = false
    }
    
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            self.isLocationPermissionGranted = false
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            self.isLocationPermissionGranted = true
        @unknown default:
            print("Unknown location authorization status")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    ///when location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
                self.locationManager.stopUpdatingLocation()
                self.findNearestSensor()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    func findNearestSensor() {
        guard let userLocation = userLocation else {return}
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        nearestSensor = sensors.min(by: {
            let distance1 = userCLLocation.distance(from: CLLocation(latitude: $0.latitude, longitude: $0.longitude))
            let distance2 = userCLLocation.distance(from: CLLocation(latitude: $1.latitude, longitude: $1.longitude))
            return distance1 < distance2
        })
        
        //get address
        guard let sensor = nearestSensor else {
            DispatchQueue.main.async {
                self.sensorAddress = "No sensor found."
            }
            return
        }
        
        Task {
            if let addressModel = await DatabaseManager.shared.fetchAddressFromCoordinates(latitude: sensor.latitude, longitude: sensor.longitude) {
                let formattedAddress = self.formatAddress(addressModel)
                DispatchQueue.main.async {
                    self.sensorAddress = formattedAddress
                }
            } 
        }
        
    }
    
    // Formats the AddressModel into a readable string
    private func formatAddress(_ address: Address) -> String? {
        if let houseNumber = address.house_number, let road = address.road {
            return "\(houseNumber) \(road)"  // "200 University Ave W"
        } else if let building = address.building {
            return building  // "E7 Engineering"
        } else if let road = address.road {
            return road  // "Ring Road"
        } else if let university = address.university {
            return university  // "University of Waterloo"
        } else {
            return nil
        }
    }
    
    
    func fetchSensorColour(for sensor: Sensor, completion: @escaping (Color?) -> Void) {
        DatabaseManager.shared.fetchLatestSelectedSensorData(selectedSensor: sensor) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sensorData):
                    completion(sensorData.getAQIColor())
                case .failure(let error):
                    completion(nil)
                }
            }
        }
    }

    
}
