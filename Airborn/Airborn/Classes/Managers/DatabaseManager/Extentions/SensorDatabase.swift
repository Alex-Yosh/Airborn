//
//  SensorDatabase.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-19.
//

import Foundation

extension DatabaseManager{
    
    ///get sensor
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
    
    ///get all sensors
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
    
    
    // MARK: NOT USED BUT MAYBE IN FUTURE
    
//    func addSensor(name: String, latitude: Double, longitude: Double, completion: @escaping (Result<Sensor, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/sensor") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let payload = ["name": name, "latitude": latitude, "longitude": longitude] as [String : Any]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            guard let data = data else { return }
//            do {
//                let sensor = try JSONDecoder().decode(Sensor.self, from: data)
//                completion(.success(sensor))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    
    ///not used
//    func deleteSensor(uuid: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/sensor/\(uuid)") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        
//        URLSession.shared.dataTask(with: request) { _, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            completion(.success(()))
//        }.resume()
//    }

}
