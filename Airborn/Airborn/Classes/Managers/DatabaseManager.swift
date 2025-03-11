//
//  DatabaseManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-16.
//

import Foundation
import SwiftUI
import Combine

class DatabaseManager: ObservableObject {
    
    static var shared = DatabaseManager()
    
    private let baseURL = "https://airborne-897502924648.northamerica-northeast1.run.app/api"
    
    private init() {}
    
    
    // MARK: - Login
    
    func loginUser(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(loginResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func signupUser(username: String, password: String, completion: @escaping (Result<SignUpResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let signupResponse = try JSONDecoder().decode(SignUpResponse.self, from: data)
                print("Signup successful! User ID: \(signupResponse.id)")
                completion(.success(signupResponse))
            } catch {
                print("JSON Decoding Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    // MARK: - Sensor Endpoints
    
    func addSensor(name: String, latitude: Double, longitude: Double, completion: @escaping (Result<Sensor, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sensor") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["name": name, "latitude": latitude, "longitude": longitude] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let sensor = try JSONDecoder().decode(Sensor.self, from: data)
                completion(.success(sensor))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getSensor(uuid: UUID, completion: @escaping (Result<Sensor, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sensor/\(uuid)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let sensor = try JSONDecoder().decode(Sensor.self, from: data)
                completion(.success(sensor))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getAllSensors(completion: @escaping (Result<[Sensor], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sensor") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let sensors = try JSONDecoder().decode([Sensor].self, from: data)
                completion(.success(sensors))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deleteSensor(uuid: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sensor/\(uuid)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
    
    // MARK: - Data Endpoints
    
    ///get average temperature for specific sensor from last 10 minutes
    func getAverageTemperature(sensorId: UUID, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/temp/avg/\(sensorId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let temperature = try JSONDecoder().decode(Double.self, from: data)
                completion(.success(temperature))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    ///get average humidity for specific sensor from last 10 minutes
    func getAverageHumidity(sensorId: UUID, completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/humidity/avg/\(sensorId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let humidity = try JSONDecoder().decode(Double.self, from: data)
                completion(.success(humidity))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    ///daily average for last 7 days
    func getCO2DailyAverages(sensorId: UUID, completion: @escaping (Result<CO2Response, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/co2/avg/\(sensorId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(CO2Response.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    ///daily average for last 7 days
    func getTVOCDailyAverages(sensorId: UUID, completion: @escaping (Result<TVOCResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/tvoc/avg/\(sensorId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TVOCResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getPM25DailyAverages(sensorId: UUID, completion: @escaping (Result<PM25Response, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/pm25/avg/\(sensorId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PM25Response.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Fetch latest sensor data from nearest sensor
    func fetchLatestNearestSensorData(completion: @escaping (SensorData?) -> Void) {
        guard let closestSensor = MapManager.shared.nearestSensor else {
            completion(nil) // Return nil if there's no closest sensor
            return
        }
        guard let url = URL(string: "\(baseURL)/data/latest/\(closestSensor.id)") else { return }
        
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> Data in
                return data
            }
            .decode(type: LatestDataResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .failure(let error):
                    completion(nil)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                completion(response.latest_reading) // Return the latest SensorData
            })
            .store(in: &cancellables)
    }
    
    /// Fetch data from selected sensor
    func fetchLatestSelectedSensorData(selectedSensor: Sensor, completion: @escaping (Result<SensorData, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/data/latest/\(selectedSensor.id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LatestDataResponse.self, from: data)
                completion(.success(decodedResponse.latest_reading))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // - MARK: -Map Endpoints
    
    // Fetches address details and returns an AddressModel
    func fetchAddressFromCoordinates(latitude: Double, longitude: Double) async -> Address? {
        let urlString = "https://nominatim.openstreetmap.org/reverse?format=json&lat=\(latitude)&lon=\(longitude)&addressdetails=1"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(NominatimResponse.self, from: data)
            
            // Convert API response to AddressModel
            return Address(
                house_number: decodedResponse.address.house_number,
                road: decodedResponse.address.road,
                building: decodedResponse.address.building,
                university: decodedResponse.address.university
            )
        } catch {
            return nil
        }
    }
}
