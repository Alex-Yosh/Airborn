//
//  DatabaseManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-16.
//

import Foundation
import SwiftUI

class DatabaseManager: ObservableObject {
    
    static var shared = DatabaseManager()
    
    private let baseURL = "https://airborne-897502924648.northamerica-northeast1.run.app/api"
    
    private init() {}
    
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
    
    func addDataEntry(data: SensorData, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
    
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
}
