//
//  UserDatabase.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-19.
//

import Foundation

extension DatabaseManager {
    
    /// Get user exposure daily average for PM2.5 for the last 7 days
    func getPM25Week(userId: UUID, completion: @escaping (Result<[ExposureData], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/pm25/avg/user/\(userId)") else { return }
        fetchData(url: url, completion: completion)
    }
    
    /// Get user exposure daily average for TVOC for the last 7 days
    func getTVOCWeek(userId: UUID, completion: @escaping (Result<[ExposureData], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/tvoc/avg/user/\(userId)") else { return }
        fetchData(url: url, completion: completion)
    }
    
    /// Get user exposure daily average for CO2 for the last 7 days
    func getCO2Week(userId: UUID, completion: @escaping (Result<[ExposureData], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/co2/avg/user/\(userId)") else { return }
        fetchData(url: url, completion: completion)
    }
    
    /// Get user exposure hourly for PM2.5 for the day
    func getPM25Day(userId: UUID, completion: @escaping (Result<[ExposureData], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/pm25/hourly/user/\(userId)") else { return }
        fetchData(url: url, completion: completion)
    }
    
    /// Get user exposure hourly for TVOC for the day
    func getTVOCDay(userId: UUID, completion: @escaping (Result<[ExposureData], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/tvoc/hourly/user/\(userId)") else { return }
        fetchData(url: url, completion: completion)
    }
    
    /// Get user exposure hourly for CO2 for the day
    func getCO2Day(userId: UUID, completion: @escaping (Result<[ExposureData], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/data/co2/hourly/user/\(userId)") else { return }
        fetchData(url: url, completion: completion)
    }
    
    /// Generic fetch function for exposure data
    private func fetchData(url: URL, completion: @escaping (Result<[ExposureData], Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode([ExposureData].self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

/// Define ExposureData model
struct ExposureData: Codable {
    let timestamp: String
    let value: Double
}
