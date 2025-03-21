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
    func getSensorWeekAverages(sensorId: UUID, type: Constants.apiAveragesEndpoint, completion: @escaping ([Double]) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/\(type.rawValue)/avg/\(sensorId)") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion([])
                return
            }
            guard let data = data else {
                completion([])
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let key = "\(type.rawValue)_daily_averages"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"

                var sortedAverages = (jsonResponse?[key] as? [[String: Any]])?
                    .compactMap { item -> (date: Date, value: Double)? in
                        guard let dateString = item["date"] as? String,
                              let value = item["average_\(type.rawValue)"] as? Double,
                              let date = dateFormatter.date(from: dateString) else { return nil }
                        return (date, value)
                    }
                    .sorted { $0.date < $1.date }
                    .map { $0.value } ?? []

                // Invert TVOC values
                if type == .tvoc {
                    sortedAverages = sortedAverages.map { $0 == 0 ? 0 : (100 - $0) }
                }

                completion(sortedAverages)

            } catch {
                completion([])
            }
        }.resume()
    }
    
    ///day for sensor
    func getSensorDayAverages(sensorId: UUID, type: Constants.apiAveragesEndpoint, completion: @escaping ([Double]) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/\(type.rawValue)/hourly/\(sensorId)") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                completion([])
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let key = "\(type.rawValue)_hourly_averages"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"  // updated format
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // or use nil to auto-parse timezone

                var sortedAverages = (jsonResponse?[key] as? [[String: Any]])?
                    .compactMap { item -> (date: Date, value: Double)? in
                        guard let dateString = item["hour"] as? String,
                              let value = item["avg_\(type.rawValue)"] as? Double,
                              let date = dateFormatter.date(from: dateString) else { return nil }
                        return (date, value)
                    }
                    .sorted { $0.date < $1.date }
                    .map { $0.value } ?? []

                // Invert TVOC values
                if type == .tvoc {
                    sortedAverages = sortedAverages.map { $0 == 0 ? 0 : (100 - $0) }
                }

                completion(sortedAverages)

            } catch {
                completion([])
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
        guard let url = URL(string: "\(baseURL)/data/latest/user/\(closestSensor.id)/\(userid)") else { return }
        
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
