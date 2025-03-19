//
//  SensorDataDatabase.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-19.
//

import Foundation

extension DatabaseManager{
    
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
    
    ///daily average for last 7 days for sensor
    func getSensorDailyAverages<T: Decodable>(sensorId: UUID, type: Constants.apiAveragesEndpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/\(type.rawValue)/avg/\(sensorId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Fetch latest sensor data from nearest sensor
    func fetchLatestNearestSensorData(completion: @escaping (LatestDataResponse?) -> Void) {
        guard let closestSensor = MapManager.shared.nearestSensor else {
            completion(nil) // Return nil if there's no closest sensor
            return
        }
        guard let userid = LoginManager.shared.uuid else {
            completion(nil)
            return
        }
        guard let url = URL(string: "\(baseURL)/data/latest/\(closestSensor.id)/\(userid)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> Data in
                return data
            }
            .decode(type: LatestDataResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .failure(_):
                    completion(nil)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                completion(response) // Return the latest SensorData
            })
            .store(in: &lastestDataCancellables)
    }
    
    // TODO: Deprecate
    /// Fetch data from selected sensoR
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
}
